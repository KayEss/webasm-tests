const fs = require('fs');
var source = fs.readFileSync(process.argv[2]);
var typed = new Uint8Array(source);

const env = {
    memoryBase: 0,
    tableBase: 0,
    memory: new WebAssembly.Memory({
      initial: 256
    }),
    table: new WebAssembly.Table({
      initial: 0,
      element: 'anyfunc'
    })
  };


function runtest(testfn, reffn) {
    let error_sq = 0, samples = 0;
    for (let v = -100; v <= 100; v += 0.1) {
        let tv = testfn(v);
        let rv = reffn(v);
        // console.log(v, tv, rv);
        let err = tv - rv;
        error_sq += err * err;
        ++samples;
    }
    return Math.sqrt(error_sq / samples);
}


WebAssembly.instantiate(typed, {env: env}).then(result => {
    var cos_err = runtest(result.instance.exports.cos, Math.cos);
    if (cos_err > 1e-14) {
        console.log("Pi error is ", cos_err);
        process.exit(1);
    }
}).catch(function() { exit(); });
