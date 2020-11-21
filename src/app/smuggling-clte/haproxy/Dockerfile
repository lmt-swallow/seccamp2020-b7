FROM ubuntu:18.04


COPY haproxy-vuln-version /haproxy
COPY haproxy.cfg /haproxy.cfg

CMD ["/haproxy", "-f", "/haproxy.cfg"]
