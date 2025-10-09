# claude generated
{ config, ... }:
{
  # Create a shared network for the containers
  systemd.services.init-tubearchivist-network = {
    description = "Create the network bridge for tubearchivist";
    serviceConfig.Type = "oneshot";
    path = [ config.virtualisation.podman.package ];
    script = ''
      # Put a true at the end to prevent getting non-zero return code, which will
      # crash the whole service.
      check=$(podman network ls | grep "tubearchivist" || true)
      if [ -z "$check" ]; then
        podman network create tubearchivist
      else
        echo "tubearchivist network already exists"
      fi
    '';
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
  };

  # Create necessary directories
  systemd.tmpfiles.rules = [
    "d /var/lib/tubearchivist 0755 root root -"
    "d /var/lib/tubearchivist/media 0755 root root -"
    "d /var/lib/tubearchivist/cache 0755 root root -"
    "d /var/lib/tubearchivist/redis 0755 root root -"
    "d /var/lib/tubearchivist/es 0750 1000 0 -" # https://github.com/tubearchivist/tubearchivist/blob/968183d21619c8374e01715605097ec1222cfe34/README.md?plain=1#L135
  ];

  # Set vm.max_map_count for Elasticsearch
  boot.kernel.sysctl = {
    "vm.max_map_count" = 262144;
  };

  # sops-nix secrets configuration
  sops.secrets = {
    tubearchivist-password = {
      owner = "root";
      group = "root";
      mode = "0400";
    };
    elasticsearch-password = {
      owner = "root";
      group = "root";
      mode = "0400";
    };
  };

  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      archivist-es = {
        image = "bbilly1/tubearchivist-es:latest";
        autoStart = true;
        environmentFiles = [
          config.sops.secrets.elasticsearch-password.path
        ];
        environment = {
          # If disk usage is an issue WARN is misleading.
          "cluster.routing.allocation.disk.threshold_enabled" = "false"; # https://github.com/tubearchivist/tubearchivist/issues/1026#issuecomment-3178520804
          ES_JAVA_OPTS = "-Xms1g -Xmx1g";
          "xpack.security.enabled" = "true";
          "discovery.type" = "single-node";
          "path.repo" = "/usr/share/elasticsearch/data/snapshot";
        };
        volumes = [
          "/var/lib/tubearchivist/es:/usr/share/elasticsearch/data:rw"
        ];
        extraOptions = [
          "--network=tubearchivist"
          "--ulimit=memlock=-1:-1"
        ];
      };

      archivist-redis = {
        image = "redis/redis-stack-server:latest";
        autoStart = true;
        volumes = [
          "/var/lib/tubearchivist/redis:/data:rw"
        ];
        extraOptions = [
          "--network=tubearchivist"
        ];
        dependsOn = [ "archivist-es" ];
      };

      tubearchivist = {
        image = "bbilly1/tubearchivist:latest";
        autoStart = true;
        ports = [ "8333:8000" ];
        environmentFiles = [
          config.sops.secrets.tubearchivist-password.path
          config.sops.secrets.elasticsearch-password.path
        ];
        environment = {
          ES_URL = "http://archivist-es:9200";
          REDIS_CON = "redis://archivist-redis";
          HOST_UID = "1000";
          HOST_GID = "1000";
          TA_HOST = "http://localhost:8333"; # Change this to your actual hostname
          TA_USERNAME = "admin";
          TZ = "Asia/Kolkata";
        };
        volumes = [
          "/var/lib/tubearchivist/media:/youtube:rw"
          "/var/lib/tubearchivist/cache:/cache:rw"
        ];
        extraOptions = [
          "--network=tubearchivist"
        ];
        dependsOn = [
          "archivist-es"
          "archivist-redis"
        ];
      };
    };
  };

  # Open firewall for TubeArchivist web interface
  networking.firewall.allowedTCPPorts = [ 8333 ];
}
