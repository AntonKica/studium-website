deploy-chodiacidotaznik:
	git push
	ssh boltie-sync@chodiacidotaznik.xyz 'cd git/studium-website; git pull; hugo; rm -rf /var/www/studium.chodiacidotaznik.xyz; cp -r public/ /var/www/studium.chodiacidotaznik.xyz/'
