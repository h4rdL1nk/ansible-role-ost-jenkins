def test_docker_server_running_and_enabled(Command, Service):
    # Check that docker service is running and enabled
    docker_service = Service("docker")
    assert docker_service.is_running
    assert docker_service.is_enabled
