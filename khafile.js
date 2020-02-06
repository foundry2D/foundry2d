let project = new Project('found');
project.addAssets('defaults/**');
project.addSources('Sources');
project.addDefine("found");
project.addParameter('found.trait');
project.addParameter("--macro keep('found.trait')");
project.addLibrary('Libraries/foundsdk/hxmath');
project.addLibrary('Libraries/foundsdk/echo');
resolve(project);