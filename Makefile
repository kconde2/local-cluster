deploy:
	@chmod +x ./deploy.sh && ./deploy.sh

cleanup:
	@chmod +x ./bin/cleanup.sh && ./bin/cleanup.sh

%:
	@chmod +x ./bin/deploy-$*.sh && ./bin/deploy-$*.sh
