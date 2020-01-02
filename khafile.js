let project = new Project('coin');
project.addAssets('defaults/**');
project.addSources('Sources');
project.addDefine("coin");
project.addParameter('coin.trait');
project.addParameter("--macro keep('coin.trait')");
project.addLibrary('/home/jsnadeau/foundsdk/hxmath');
project.addLibrary('/home/jsnadeau/foundsdk/echo');
resolve(project);