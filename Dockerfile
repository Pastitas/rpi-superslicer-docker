FROM debian:buster-slim

# Setup demo environment variables
ENV HOME=/root \
	DEBIAN_FRONTEND=noninteractive \
	LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8 \
	LC_ALL=C.UTF-8 \
	DISPLAY=:0.0 \
	DISPLAY_WIDTH=1024 \
	DISPLAY_HEIGHT=768

# Install git, supervisor, VNC, & X11 packages
RUN apt-get update && apt-get install -y \
	bash \
	fluxbox \
	git \
	net-tools \
	openssh-client \
	socat \
	supervisor \
	x11vnc \
	xterm \
	xvfb \
    ca-certificates \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Clone noVNC from github
RUN git clone https://github.com/novnc/noVNC.git /root/noVNC \
	&& git clone https://github.com/novnc/websockify.git /root/noVNC/utils/websockify \
	&& rm -rf /root/noVNC/.git \
	&& rm -rf /root/noVNC/utils/websockify/.git

# Clone Superslicer from github
RUN git clone https://github.com/supermerill/SuperSlicer.git /root/superslicer \
    &&  rm -rf /root/superslicer/.git

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8080

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]