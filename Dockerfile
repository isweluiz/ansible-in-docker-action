FROM isweluiz/ansible-docker-action:1.0.0
LABEL MAINTEINER="Luiz"

COPY entrypoint.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
