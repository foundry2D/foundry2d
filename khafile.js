let project = new Project('found');
project.addAssets('defaults/**');
project.addSources('Sources');
project.addDefine("found");
project.addParameter('found.trait');
project.addParameter("--macro keep('found.trait')");
project.addLibrary('/home/jsnadeau/foundsdk/hxmath');
project.addLibrary('/home/jsnadeau/foundsdk/echo');
resolve(project);