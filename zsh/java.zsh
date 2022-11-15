#
# Java
jdk() {
version=$1
export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
}
jdk 16