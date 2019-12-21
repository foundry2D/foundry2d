let project = new Project('coin');
project.addAssets('defaults/**');
project.addSources('Sources');
project.addDefine("coin");
project.addParameter('coin.trait');
project.addParameter("--macro keep('coin.trait')");
resolve(project);