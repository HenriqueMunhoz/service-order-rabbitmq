function app_env {
    local envs=$(env | egrep '^BIFROST_' | sed 's/^/ -e /')
    local rails_env=$( [[ -n "${RAILS_ENV}" ]] && printf " -e RAILS_ENV=${RAILS_ENV}" )
    printf "%s " "$envs $rails_env" | xargs printf " %s"
}

function fix_linux_internal_host() {
    DOCKER_INTERNAL_HOST="host.docker.internal"
    if ! grep $DOCKER_INTERNAL_HOST /etc/hosts > /dev/null ; then
        DOCKER_INTERNAL_IP=`/sbin/ip route | awk '/default/ { print $3 }'`
        echo -e "$DOCKER_INTERNAL_IP\t$DOCKER_INTERNAL_HOST" | tee -a /etc/hosts > /dev/null
        echo "Added $DOCKER_INTERNAL_HOST to hosts /etc/hosts"
    fi
}
export WORKDIR="$(dirname "${BASH_SOURCE[0]}")/.."
export DOCKER_COMPOSE="docker-compose -f $WORKDIR/docker-compose.yml"
