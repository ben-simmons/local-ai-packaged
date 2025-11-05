#!/usr/bin/env zsh

localai_root() {
    local script_path=${(%):-%x}
    local script_dir=${script_path:A:h}
    echo $script_dir
}

localai_pull() {
    cd $(localai_root)

    # Pull latest versions of all containers
    docker -f docker-compose.yml --profile none pull
}

localai_start() {
    cd $(localai_root)

    python start_services.py --profile none
}

localai_stop() {
    cd $(localai_root)

    docker compose -p localai --profile none down --remove-orphans
}