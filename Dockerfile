# base image
FROM ubuntu:xenial

# label with HEAD commit if given
ARG GIT_COMMIT=unspecified
LABEL git_commit=$GIT_COMMIT

# Install the packages we need. Avahi will be included
RUN apt-get update && apt-get install -y \
	cups \
	tree \
&& rm -rf /var/lib/apt/lists/*

# This will use port 631
EXPOSE 631

# We want a mount for these
VOLUME /config
VOLUME /services

# Add scripts and install hp136w driver -- uld
ADD root /
RUN chmod +x /root/*  && \
	tar  -xzvf "/root/uld-hp_V1.00.39.12_00.15.tar.gz" && \
	pwd && \
	ls -al  && \
	
	chmod +x /root/uld/*.sh && \
echo " \
" | /root/uld/install.sh
#CMD ["/root/uld_install.sh"]
CMD ["/root/run_cups.sh"]

# Baked-in config file changes
RUN sed -i 's/Listen localhost:631/Listen 0.0.0.0:631/' /etc/cups/cupsd.conf && \
	sed -i 's/Browsing Off/Browsing On/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/>/<Location \/>\n  Allow All/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/admin>/<Location \/admin>\n  Allow All\n  Require user @SYSTEM/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/admin\/conf>/<Location \/admin\/conf>\n  Allow All/' /etc/cups/cupsd.conf && \
	echo "ServerAlias *" >> /etc/cups/cupsd.conf && \
	echo "DefaultEncryption Never" >> /etc/cups/cupsd.conf && \
	rm -rf /root/uld*
