FROM nginx:1.25.4-alpine

LABEL org.opencontainers.image.authors="Andreas Heil @aheil@chaos.social"

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Create directory for SSL certificates
RUN mkdir -p /etc/nginx/ssl

# Expose ports
EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"] 