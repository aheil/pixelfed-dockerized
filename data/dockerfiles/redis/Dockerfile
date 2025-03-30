FROM redis:7.2-alpine

LABEL org.opencontainers.image.authors="Andreas Heil @aheil@chaos.social"

# Create directory for Redis data
RUN mkdir -p /data

# Set permissions
RUN chown -R redis:redis /data

# Expose Redis port
EXPOSE 6379

CMD ["redis-server", "--appendonly", "yes"] 