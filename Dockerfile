# Use a slim Debian-based Python image
FROM python:3.11-slim-bullseye

# avoid interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies: Apache, PHP, build tools, nano, git, etc.
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      apache2 \
      libapache2-mod-php \
      php-cli \
      build-essential \
      python3-dev \
      nano \
      git \
 && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install Python development tools
RUN pip install --no-cache-dir --upgrade pip \
 && pip install --no-cache-dir \
      poetry \
      black \
      flake8 \
      pylint

# Set up nano syntax-highlighting
RUN git clone https://github.com/scopatz/nanorc.git /opt/nanorc \
 && echo "include /opt/nanorc/*.nanorc" >> /etc/nanorc

# Enable Apache PHP module (automatically loaded when libapache2-mod-php is installed)
# You can enable extra modules here if needed:
# RUN a2enmod rewrite

# Configure Apache: adjust DocumentRoot if you like
# Copy your code into /var/www/html, or mount it as a volume at runtime
WORKDIR /var/www/html

# Expose HTTP port
EXPOSE 80

# Run Apache in the foreground
CMD ["apache2ctl", "-D", "FOREGROUND"]
