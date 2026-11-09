# goemon-cgi

A Docker-based playground for running Goemon (Kama) programs as CGI on Apache.

## Setup

```bash
git clone --recurse-submodules <repository URL>
cd goemon-cgi
docker build -t kama-cgi .
```

## Build pages

```bash
mkdir -p dist
docker run --rm -v "$(pwd):/work" -w /work kama-cgi /app/goemon-src/kama-c pages/page.goe dist/page.gb
```

The compiled bytecode (`.gb`) is written to `dist/`.

## Start the server

```bash
docker run --rm -p 8080:80 -v "$(pwd)/dist:/app/dist:ro" -v "$(pwd)/cgi-bin:/usr/local/apache2/cgi-bin:ro" kama-cgi
```

Open http://localhost:8080/cgi-bin/page.cgi to check the page. Press `Ctrl+C` to stop the server.

## Update goemon-src

```bash
cd goemon-src && git pull origin main && cd ..
git commit -am "Update: goemon-src to latest"
docker build -t kama-cgi .
```

Rebuild the image after updating so that `kama-c` and `kama-e` inside it are up to date.

## Troubleshooting

If the script source is returned as plain text, check that the CGI module is enabled:

```bash
docker run --rm kama-cgi grep -n "LoadModule cgi" /usr/local/apache2/conf/httpd.conf
```

The module is enabled if the `LoadModule cgid_module` line does not start with `#`.