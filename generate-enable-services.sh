PRESET_PATH="$(pwd)/main_enable_services.bu"
COMPOSE_PATH="$(pwd)/docker-compose"

cd $COMPOSE_PATH

echo "variant: fcos" > $PRESET_PATH;
echo "version: 1.4.0" >> $PRESET_PATH;
echo "storage:" >> $PRESET_PATH;
echo "  links:" >> $PRESET_PATH;

for dir in *; do
	echo "    - path: /etc/systemd/system/multi-user.target.wants/docker-compose@$dir.service" >> $PRESET_PATH;
	echo "      overwrite: true" >> $PRESET_PATH;
	echo "      target: /etc/systemd/system/docker-compose@.service" >> $PRESET_PATH;
done
