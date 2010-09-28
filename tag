#!/usr/bin/python

import optparse
import sys
import os

"""

tag.py

creates a tagging system based on symbolic links

"""

tagDirectory = 'tagged'


def main():
	
	try:
		p = optparse.OptionParser()
		p.add_option('--add', '-a', action='store_true',  help="add tags to file(s)")
		p.add_option('--remove', '-r', action='store_true',  help="remove tags from file(s)")
		p.add_option('--tags', '-t', action='store', dest='tags', help="set of tags to apply/remove")
		global opts, args
		opts, args = p.parse_args()
	except optparse.OptParseError, err:
		print str(err)
		sys.exit(-1)
	
	if opts.add:
		addTags()
	elif opts.remove:
		removeTags()
	else:
		"""default action is to list all available tags from the current directory"""
		listTags()


def addTags():
	global opts, args
	tags = opts.tags.split(',')
	for file in args:
		for tag in tags:
			addTag(file, tag.strip())
	pass
	
def removeTags():
	print "removeTags()"
	pass

def addTag(path, tag):
	if os.path.isdir(path):
		work_dir = os.path.normpath(path + '../')
		fname = os.path.dirname(path)
	else:
		work_dir = os.path.dirname(path)
		fname = os.path.basename(path)

	tagDir = "%s/%s/%s" % (work_dir, tagDirectory, tag)
	try:
		os.makedirs(tagDir)
	except OSError, err:
		print "%s (but don't let that worry you...)" % (str(err))
	
	relativePath = os.path.relpath(fname, tagDir)
	
	if not os.path.exists("%s/%s" % (tagDir, fname)):
		os.symlink(relativePath, "%s/%s" % (tagDir, fname))
	else:
		print "file already had the tag '%s'" % (tag)
	

def listTags():
	global tagDirectory
	
	print "Listing existing tags:"
	files = os.listdir("./%s/" % tagDirectory)
	for file in files:
		print file

if __name__ == '__main__':
	main()
