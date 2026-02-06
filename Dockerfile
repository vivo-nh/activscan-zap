FROM zaproxy/zap-stable:latest

USER root
WORKDIR /zap-service

COPY start.sh /zap-service/start.sh
RUN sed -i 's/\r$//' /zap-service/start.sh && chmod +x /zap-service/start.sh

# Render routes to $PORT; EXPOSE is informational, so set it to 10000 as a neutral default
# (the actual listening port is still controlled by $PORT at runtime).
EXPOSE 10000

CMD ["/zap-service/start.sh"]
