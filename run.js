const {prompt} = require("inquirer");
const fs = require("fs");
const {exec} = require("child_process");

/** @returns {String[]} */
function walk(dir) {
  if (!fs.statSync(dir).isDirectory()) {
    return [dir];
  }

  let files = [];

  fs.readdirSync(dir).forEach(file => {
    if (fs.statSync(dir + "/" + file).isDirectory()) {
      files = files.concat(walk(dir + "/" + file));
    } else {
      files.push(dir + "/" + file);
    }
  });

  return files;
};

/** @returns {String[]} */
const getScripts = ({scripts}) => {
  let ends = ['.js', '.mjs', '.cjs'];
  if (!scripts.includes('home')) {
    if (scripts.includes('nodeModules')) {
      return walk("node_modules").sort()
        .filter(file => {
          if (!scripts.includes('nodeBin')) {
            return file.startsWith('node_modules/.bin');
          }
          return true;
        });
    } else {
      return walk("node_modules/.bin").sort();
    }
  } else {
    return walk(".").sort()
      .filter(file => {
        if (!scripts.includes('nodeBin') && file.startsWith('./node_modules./.bin')) {
          return false;
        } else if (!scripts.includes('nodeModules') && file.startsWith('./node_modules') && !file.startsWith('./node_modules/.bin')) {
          return false;
        } else {
          return true;
        }
      })
      .filter(file => ends.includes(file.substring(file.lastIndexOf('.'))));
  }
};

prompt({
  name: 'scripts',
  type: 'checkbox',
  message: 'From which locations do you want to import your scripts?',
  choices: [
    {
      key: 'home',
      name: 'Home directory (.)',
      type: 'choice',
      checked: true,
      value: 'home'
    } , {
      key: 'nodeBin',
      name: 'NodeModules Bin Directory (node_modules/.bin)',
      type: 'choice',
      checked: true,
      value: 'nodeBin'
    } , {
      key: 'nodeModules',
      name: 'All NodeJS Modules (node_modules)',
      type: 'choice',
      checked: false,
      value: 'nodeModules'
    }
  ]
})
  .then(dirs => {
    prompt([
      {
        name: 'script',
        type: 'list',
        message: 'Which script do you want to execute?',
        choices: getScripts(dirs).map(file => {
          return {
            key: file.substring(file.lastIndexOf('/') + 1).substring(0, file.lastIndexOf('.')).toLowerCase(),
            name: file,
            type: 'choice',
            value: file
          };
        }),
        pageSize: 15
      } , {
        name: 'extra',
        type: 'input',
        message: 'Please provide any extra arguments you want to supply'
      }
    ])
      .then(answer => {
        let extra = answer.extra;

        exec(`node ${answer.script} ${extra}`, (err, stdout) => {
          if (err) {
            console.error('Error =>\n' + err);
            return;
          }

          console.log(stdout);
          console.log('Success!');
        });
      })
      .catch(console.error);
  }).catch(console.error);
