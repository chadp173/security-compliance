import configparser
import json
import logging
import logging.config
import pendulum
import sys, os
from tenable.io import TenableIO


logging.config.fileConfig(fname='logging.cfg', disable_existing_loggers=False)
logger = logging.getLogger(os.path.basename(__file__))

def main(now):

	config = configparser.ConfigParser()
	config.read('setup.cfg')

	accessKey = config['nessus']['accessKey']
	secretKey = config['nessus']['secretKey']
	nessusUrl = config['nessus']['baseUrl']

	tio = TenableIO(
		access_key=accessKey,
		secret_key=secretKey,
		url=nessusUrl
	)
	scans = tio.scans.list()
	for scan in scans:
		print(f'Scan {scan["id"]} is named {scan["name"]}')

if __name__ == '__main__':

	logger.info('#' * 60)
	logger.info('	- Running app.py report - ')
	logger.info('#' * 60)

	now = pendulum.now('America/Chicago')

	try:
		main(now)
	except Exception:
		logger.error("Looks like sompthin failed...", exc_info=True)
