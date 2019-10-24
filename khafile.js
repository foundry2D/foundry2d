let project = new Project('coin');
project.addAssets('defaults/**');
project.addSources('Sources');
project.addDefine("debug");
project.addParameter('coin.trait.internal.LoadingScript');
project.addParameter("--macro keep('coin.trait.internal.LoadingScript')");
resolve(project);