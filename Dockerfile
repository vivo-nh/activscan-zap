FROM zaproxy/zap-stable:latest

USER root
WORKDIR /zap-service

COPY start.sh /zap-service/start.sh
RUN sed -i 's/\r$//' /zap-service/start.sh && chmod +x /zap-service/start.sh

# IMPORTANT:
# The base image defines an ENTRYPOINT that can bypass/override CMD.
# Force our script to be the entrypoint so we control the port binding.
ENTRYPOINT ["/zap-service/start.sh"]

# EXPOSE is informational; Render uses $PORT at runtime.
EXPOSE 10000
