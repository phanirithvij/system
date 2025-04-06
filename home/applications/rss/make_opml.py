# TODO nix-shell shebang
# but editor won't work then
import xml.etree.ElementTree as ET
import requests
import sys

with open("feeds.json", "w+", encoding="utf-8") as f:
    r = requests.get("https://indieblog.page/export")
    data = r.json()

    # Create the OPML structure
    opml = ET.Element("opml", version="2.0")
    head = ET.SubElement(opml, "head")
    title = ET.SubElement(head, "title")
    title.text = "IndieBlog.page Feed Export"
    body = ET.SubElement(opml, "body")

    for x in data:
        outline = ET.SubElement(
            body, "outline", type="rss", xmlUrl=x["feedurl"], text=x["feedtitle"]
        )

    # Write the OPML file
    tree = ET.ElementTree(opml)
    tree.write(sys.stdout.buffer, encoding="utf-8", xml_declaration=True)

    _ = f.write(r.text)
