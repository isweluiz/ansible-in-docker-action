FROM iswelui/ansible-docker-action:PR-13-1.1.0
#1.0.0
LABEL MAINTEINER="@isweluiz"

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
