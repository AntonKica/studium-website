deploy-chodiacidotaznik:
	git push
	ssh website@studium.chodiacidotaznik.xyz 'cd studium-website && git pull && hugo'
