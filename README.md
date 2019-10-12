#When to use

This is to be use for moving the site or setting up new ones.

#How

##Webhooks

The webhook is how we notify mkdocs to regenerate the static HTML for the site.

Run the hook generator script, this will create a special user and start a webserver under their account. After this is done you will be given a URL that should be added to the github repository under the "webhooks" GUI in the web interface. Now when you make commits to change the sites source the site will be rebuilt and served under that URL. You can then proxy it (via EG nginx or cloudflare) to put it under the correct port, dommain name, and SSL certificate.

##Theme

The theme is here duplicated for refrence. If you use it on your own site make sure you replace our SVG logo near the top. The logo is included inline to make themeing easier. The site uses three colors, changing the style variables will effect the entier theme. You should not write color literals except in the variables.

 1) fg: the fouground dark grey text color 
 2) bg: the background light green color
 3) hg: the "highlight" color used for links and the logo

 To install the theme edit mkdocs.yml
 	

 	theme:
	 name: null
	 custom_dir: 'theme/'

Then create a folder called "theme" in the root of your repo and add main.html to that folder.

Our theme is extremely minimal. The following is what is expected to work:

 1) Section headings (they will all be the same size) 
 2) Animated lists (this can be easily disabled by commenting out the animation section in the style)
 3) Table of contents (tested for responsiveness)
 4) An SVG logo on the index page (inherets style, this is why it's inline)
 5) Site navigation in the footer
 6) An edit button that points to your Repo URL
 7) Anchors
 8) Images (which are all resized for a 1:1 aspect ratio, take up 7ems, and centered)


It is not a complete mkdocs theme, many of the standard features are missing.


##CI script

The "CI" script in the repo is called by the hook script generated in the first section. It is what calls mkdocs to generate the HTML. We're not generating any real software so to call this "CI" is a stretch but it's nice if you want something minimal that matches patterns other people use with git.

