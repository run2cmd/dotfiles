# Load sdkman
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Never run gradle daemon. For multiple project causes perfomrance issues.
export GRADLE_OPTS=-Dorg.gradle.daemon=false

# Limit JAVA to not kill OS
export JAVA_OPTS='-Xms256m -Xmx2048m'

# Allow broken certs for maven
export MVN_ARGS='-Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -Dmaven.wagon.http.ssl.ignore.validity.dates=true -Dmaven.resolver.transport=wagon'
