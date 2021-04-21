import logging

formatter = logging.Formatter(
fmt='%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s',
datefmt='\n%Y-%m-%d %H:%M:%S')

logger = logging.getLogger(__file__)
logger.setLevel(logging.DEBUG)
ch = logging.StreamHandler()
ch.setFormatter(formatter)
fh = logging.FileHandler("log"+".log")
fh.setFormatter(formatter)
logger.addHandler(ch)
logger.addHandler(fh)

#logger.info('This is a info log.')
#logger.error('This is a error log.')

def loglog(log):
    logger.info(log)