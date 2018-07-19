FROM centos:7

# Install updates
RUN yum -y update

# Install required packages
RUN yum install -y yum-utils psmisc

# System time to UTC
RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime

# Add 2600Hz RPM server
# You can find the latest 4.0 RPM here: https://packages.2600hz.com/centos/7/stable/2600hz-release/4.0/
RUN curl -o 2600hz-release-4.1-0.el7.centos.noarch.rpm -k \
    https://packages.2600hz.com/centos/7/staging/2600hz-release/4.1/2600hz-release-4.1-0.el7.centos.noarch.rpm
RUN yum install -y 2600hz-release-4.1-0.el7.centos.noarch.rpm
RUN rm 2600hz-release-4.1-0.el7.centos.noarch.rpm

# Install Kazoo-wrapped FreeSWITCH
RUN yum install -y kazoo-freeswitch

# Clear yum cache
RUN yum clean all

COPY entrypoint /
RUN chmod +x /entrypoint

ENTRYPOINT ["/entrypoint"]
CMD ["/usr/sbin/kazoo-freeswitch", "start", "-nc", "-nf"]
