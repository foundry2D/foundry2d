let project = new Project('found');
project.addAssets('defaults/**');
project.addSources('Sources');
project.addDefine("found");
project.addParameter('found.trait');
project.addParameter("--macro keep('found.trait')");
project.addParameter('found.node');
project.addParameter("--macro keep('found.node')");
// @TODO: Fix strict null safety issues by enabling this and fixing the compile issues
// project.addParameter('--macro nullSafety("found", Strict)');
project.addLibrary('Libraries/foundsdk/hxmath');
project.addLibrary('Libraries/foundsdk/echo');
project.addLibrary('Libraries/foundsdk/zui');
resolve(project);