FROM zaproxy/zap-stable:latest

USER root
WORKDIR /zap-service

COPY start.sh /zap-service/start.sh
RUN sed -i 's/\r$//' /zap-service/start.sh && chmod +x /zap-service/start.sh

EXPOSE 8090
CMD ["/zap-service/start.sh"]
