FROM iswelui/ansible-docker-action:1.0.0
LABEL MAINTEINER="Luiz"

COPY run.sh /run.sh
RUN chmod +x /run.sh

echo "dev"

ENTRYPOINT ["/run.sh"]
