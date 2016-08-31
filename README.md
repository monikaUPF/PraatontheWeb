# Praat on the Web
Web implementation of the entension of Praat for feature annotation available for local use under https://github.com/monikaUPF/featureAnnotationforPraat. 

A tutorial on the use of the basic functions of the web implementation of Praat for feature annotations is available in the following link https://youtu.be/sJXu15Dskjs

The link to the web application is http://kristina.taln.upf.edu/praat_web/ and it is described in our publication (Domínguez et al. 2016)

###############
## Content
###############

This repository includes source code and documentation.

###############
## Structure
###############

Inside PraatWeb folder you can find two subdirectories:
  - src/edu/upf/dtic
  - WebContent

In the first one you will find all Java files divided in servlets and classes folders.
In WebContent you will find all JSP, style sheets and JavaScript files, plus several folders:
  - images
  - META-INF
  - samples
  - scripts
  - tmp
  - WEB-INF

In images folder there are the images used in the web.
In META-INF folder you can find the MANIFEST.MF file.
In samples folder there are the audio and TextGrid files used as samples in the web.
In scripts folder there are all the Praat scripts used in the web.
Tmp is an empty folder used to temporary save the content generated via web by the users.
In WEB-INF folder you can find the web.xml file.

#################
## Specifications
#################

The application uses the MVC pattern with Java servlet model and is mainly developed in Java, JSP with style sheets and JavaScript. Using the following existent external libraries:
  - jQuery
  - Bootstrap
  - wavesurfer.js
  - Sortable

#####################
## References and Citation
#####################

If you use this software or modify the code please cite the following publication:

  - Domínguez, M., I. Latorre, M. Farrús, J. Codina and L. Wanner (2016). Praat on the Web: An Upgrade of Praat for Semi-Automatic Speech Annotation. Under submission
