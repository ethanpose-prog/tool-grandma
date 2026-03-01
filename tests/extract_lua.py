import xml.etree.ElementTree as ET
import os

xml_path = "/home/ethan/.picoclaw/workspace/projects/tool-grandma/plugins-ma3/ClawChat.xml"
lua_out = "/home/ethan/.picoclaw/workspace/projects/tool-grandma/tests/extracted_plugin.lua"

tree = ET.parse(xml_path)
root = tree.getroot()

# Find the LuaCode content
lua_code = root.find(".//LuaCode").text

with open(lua_out, "w") as f:
    f.write(lua_code)

print(f"Code Lua extrait vers {lua_out}")
