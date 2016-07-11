# Qiita Markdown Server

[Qiita Markdown Server](https://github.com/suin/docker-qiita-markdown-server) converts Markdown to HTML via JSON API.

# API Reference

## POST /markdown

This endpoint receives Markdown and responds HTML.

### Request Parameters

Name | Type | Description
-----|------|------------
text | string | Markdown text to be converted into HTML **(Required)**
options | object | Markdown processor options. See [qiita-markdown documentation] for detail

[qiita-markdown documentation]: https://github.com/increments/qiita-markdown#context

#### Example

```http
POST /markdown HTTP/1.1
Accept: application/json
Content-Length: 278
Content-Type: application/json; charset=utf-8
Host: qmd.docker

{
    "text": "hello :smile: @suin @foo @bar <script>alert(1)</script>\n\n```rb\nputs 1\n```",
    "options": {
        "allowed_usernames": [
            "suin",
            "foo"
        ],
        "asset_root": "https://assets-cdn.github.com/images/icons",
        "base_url": "https://twitter.com",
        "script": true
    }
}
```

### Response

```http
HTTP/1.1 200 OK
Connection: keep-alive
Content-Length: 659
Content-Type: application/json;charset=utf-8
Date: Sun, 10 Jul 2016 14:34:02 GMT
Server: nginx/1.9.12
X-Content-Type-Options: nosniff

{
    "codes": [
        {
            "code": "puts 1\n",
            "filename": null,
            "language": "rb"
        }
    ],
    "mentioned_usernames": [
        "suin",
        "foo"
    ],
    "output": "<p>hello <img class=\"emoji\" title=\":smile:\" alt=\":smile:\" src=\"https://assets-cdn.github.com/images/icons/emoji/unicode/1f604.png\" height=\"20\" width=\"20\" align=\"absmiddle\"> <a href=\"https://twitter.com/suin\" class=\"user-mention\" title=\"suin\">@suin</a> <a href=\"https://twitter.com/foo\" class=\"user-mention\" title=\"foo\">@foo</a> @bar <script>alert(1)</script></p>\n\n<div class=\"code-frame\" data-lang=\"rb\"><div class=\"highlight\"><pre>\n<span class=\"nb\">puts</span> <span class=\"mi\">1</span>\n</pre></div></div>\n"
}
```

# Installation

Qiita Markdown Server is dockerized so you can pull docker image from Docker Hub and run it.

```console
docker run -it --rm -p 80:80 suin/qiita-markdown-server
```

This container is also available on Docker Compose.

```yaml:docker-compose.yml
qms:
  image: suin/qiita-markdown-server
  ports:
    - 80:80
```
