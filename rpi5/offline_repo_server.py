#!/usr/bin/env python3
from http.server import ThreadingHTTPServer, SimpleHTTPRequestHandler
import os

ROOT = "/home/dheeraj/PS5-OFFLINE"
HOST = "0.0.0.0"
PORT = 8080

class Handler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Cache-Control", "no-store")
        super().end_headers()

os.chdir(ROOT)
print(f"Dheeraj PS5 offline repository: http://{HOST}:{PORT}/payloads.json")
ThreadingHTTPServer((HOST, PORT), Handler).serve_forever()
