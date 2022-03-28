deploy:
	chmod +x ./deploy.sh && ./deploy.sh

mysql:
	chmod +x ./bin/deploy-mysql.sh && ./bin/deploy-mysql.sh

cleanup:
	chmod +x ./bin/cleanup.sh && ./bin/cleanup.sh
