# Praat on the Web
Web implementation of the extension of Praat for feature annotation also available for local use and downloadable separately from the following repository https://github.com/monikaUPF/featureAnnotationforPraat. 

A tutorial on the use of the basic functions of the web implementation of Praat for feature annotations is available in the following link https://youtu.be/sJXu15Dskjs

The link to the web application was http://kristina.taln.upf.edu/praatweb/ and it is described in our publication (Domínguez et al. 2016). There has been a migration of the web to https://langwiki.org/praatweb/index.jsp

###############
## Content
###############

This repository includes source code and documentation.

#################
## Specifications
#################

The application uses the MVC pattern with Java servlet model and is mainly developed in Java, JSP with style sheets and JavaScript. Using the following existent external libraries:
  - jQuery
  - Bootstrap
  - wavesurfer.js
  - Sortable


###############
## Folder Structure
###############

PraatWeb folder includes two subdirectories:
  - src/edu/upf/dtic: contains all Java files divided in servlets and classes folders
  - WebContent: contains all JSP, style sheets and JavaScript files, plus several folders:
    - images: pictures used in the web
    - META-INF: the MANIFEST.MF file
    - samples: audio and TextGrid files used as samples in the web
    - scripts: all the Praat scripts used in the web demos
    - tmp: empty folder used to temporary save the content generated via web by the users
    - WEB-INF: web.xml file


#####################
## References and Citation
#####################

If you use this software and/or modify the code please cite the following publication:

  - Domínguez, M., I. Latorre, M. Farrús, J. Codina and L. Wanner (2016). Praat on the Web: An Upgrade of Praat for Semi-Automatic Speech Annotation.  In Proceedings of the 25th International Conference on Computational Linguistics, Osaka, Japan.
