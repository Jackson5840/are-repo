var activearchives
var loadcount
var ingestcount
var neur
var dm


$(document).ready(function() {
    activearchives = JSON.parse(getarchives()).data
    createArchivePanel(activearchives);
    createDataPanel(activearchives)
});

function getarchives() {
    //get archives available - called on load
    dm = {};    
    return $.ajax({
        url: 'http://127.0.0.1:5000/getarchives',
        async: !1,
        error: function () {
            console.log("Error!");
        },
        success: function (result) {
            console.log(result);
            activearchives = result.data;			
        },
        type: 'GET'
    }).responseText;
}

function readarchives() {
    /* read available archives - on clicking "read archives"
        returns archives and their statuses.
    */

    part = 100/activearchives.length
    loadcount = 0;
    abutton = document.getElementById("read_button");
    abutton.classList.add('disabled');
    activearchives.forEach(archive => {
        
        $.ajax({
        url: 'http://127.0.0.1:5000/readarchive/' + archive.name,
        error: function () {
            console.log("Error!");
        },
        success: function (result) {
            console.log(result)
            loadcount++
            if (result.status == 'error') {
                abutton = document.getElementById(archive.name + "_button")
                abutton.classList.remove('btn-secondary')
                abutton.classList.add('btn-danger')
                abutton = document.getElementById("read_button")
                abutton.classList.add('enabled')
                          
            }
            else {
                abutton = document.getElementById(archive.name + "_button")
                abutton.classList.remove('btn-secondary')
                abutton.classList.add('btn-info')
                

            }
            abuttontext = document.getElementById(archive.name + "_message")  
            abuttontext.innerHTML = result.message
            if (Math.round(loadcount * part) == 100) { 
                anelem = document.getElementById("archivebar")
                anelem.classList.remove('progress-bar-animated')
                anelem.classList.remove('progress-bar-striped')
                activearchives = JSON.parse(getarchives()).data
                abutton = document.getElementById("read_button");
                abutton.classList.remove('disabled');
                document.querySelector("body > main").innerHTML = ""
                createDataPanel(activearchives)
            }
            document.getElementById("archivebar").style.width = (loadcount * part).toString() + '%';  			
        },
        type: 'GET'
        }); 
    });
}





function createArchivePanel(archives) {
    pcontent =
    `<div class="card">
        <div class="card" style="width: 100%;">
        <div class="card-body">
        <h5 class="card-title">Available archives</h5>
        <div class="bd-example">`
    archives.forEach(archive => {
        switch (archive.status) {
            case 'ready':
                btnclass = 'btn-secondary'
                break;
            case 'error':
                btnclass = 'btn-danger'
                break;
            case 'partial':
                btnclass = 'btn-warning'
                break;
            case 'read':
                btnclass = 'btn-info'
                break;
            case 'ingested':
                btnclass = 'btn-success'
                break;
            default:
                btnclass = 'btn-secondary'
                break;
        }
        pcontent += `
        <div class="btn-group">
        <button id="${archive.name}_button" type="button" class="btn ${btnclass} dropdown-toggle m-1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">${archive.name}</button>
        <div class="dropdown-menu p-4 text-muted" style="max-width: 200px;">
        <p id="${archive.name}_message">
            ${archive.message}.
        </p>
        </div>
        </div>`;
    });
    pcontent += `</div>

       <p class="card-text"></p>
       <a id="read_button" href="#" class="btn btn-primary" onclick="readarchives()">Read archives</a>
    </div> <div class="progress">
    <div id='archivebar' class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%"></div>
  </div> <br/>
    </div>`


    $(pcontent).appendTo(".archivecont");
}


function ingestneuron(archive,icount) {
    neuron = archive.neurons[icount];
    part = 1 / archive.neurons.length;

    console.log('Ingesting neuron: ' + neuron.neuron_name);
    if (neuron.status != "ingested") {
        $.ajax({
            url: 'http://127.0.0.1:5000/ingestneuron/' + neuron.neuron_name,
            error: function () {
                console.log("Error!");
            },
            type: 'GET',
            success: function(result) {
                $("#inglog").innerHTML = 
                abutton = document.getElementById(neuron.neuron_name + "_button");
                abutton.classList.remove('btn-secondary');
                if (result.status == 'error') {
                    abutton.classList.add('btn-danger');

                    abar = document.getElementById('cnt' + archive.name + 2)
                    abarwidth = parseFloat(abar.style.width.slice(0,-1)) + part * 100;
                    abar.style.width = (abarwidth).toString() + '%';
                }
                else {
                    abutton.classList.add('btn-success');

                    abar = document.getElementById('cnt' + archive.name + 3)
                    abarwidth = parseFloat(abar.style.width.slice(0,-1)) + part * 100;
                    abar.style.width = (abarwidth).toString() + '%';
                }
                readybar = document.getElementById('cnt' + archive.name + 1);
                readybarwidth = parseFloat(readybar.style.width.slice(0,-1))-part * 100;
                readybar.style.width = (readybarwidth).toString() + '%';
                
                abuttontext = document.getElementById(neuron.neuron_name  + "_message") ; 
                abuttontext.innerHTML = result.message;

                neuronlink = document.getElementById(neuron.neuron_name  + "_link") ;
                neuronlink.classList.remove('disabled');

                neuroningest = document.getElementById(neuron.neuron_name  + "_ingest") ;
                neuroningest.classList.add('disabled');
                
                anelem = document.getElementById(archive.name + "_button");
                anelem.classList.remove('btn-info');
                anelem.classList.add('btn-warning');

                console.log(Math.round(part))
                if (Math.round((icount+1)*part*100) == 100) { 
                    anelem = document.getElementById('cnt' + archive.name + 1);
                    anelem.classList.remove('progress-bar-animated');
                    anelem.classList.remove('progress-bar-striped');
                    
                    anelem = document.getElementById('cnt' + archive.name + 2);
                    anelem.classList.remove('progress-bar-animated');
                    anelem.classList.remove('progress-bar-striped');
                    //readybarwidth = parseFloat(anelem.style.width.slice(0,-1))-part*100;
                    readybar.style.width = '0%';

                    anelem = document.getElementById('cnt' + archive.name + 3);
                    anelem.classList.remove('progress-bar-animated');
                    anelem.classList.remove('progress-bar-striped');

                    anelem = document.getElementById(archive.name + "_button");
                    anelem.classList.remove('btn-info');
                    anelem.classList.remove('btn-warning');
                    anelem.classList.add('btn-success');
                }
                else {
                    ingestneuron(archive,icount+1);
                    
                }   
            }
        })
    }
    else {
        ingestneuron(archive,icount+1);
    }    
}

function ingestwrap(neuron_name,archive_name) {
    notFound = true;
    var anarchive; 
    ix = -1;
    while (notFound) {
        ix++
        notFound = activearchives[ix].name != archive_name;
    }
    archive = activearchives[ix]

    part = 1 / archive.neurons.length;
    console.log('Ingesting neuron: ' + neuron_name);
    $.ajax({
        url: 'http://127.0.0.1:5000/ingestneuron/' + neuron_name,
        error: function () {
            console.log("Error!");
        },
        type: 'GET',
        success: function(result) {
            $("#inglog").innerHTML = 
            abutton = document.getElementById(neuron_name+ "_button");
            abutton.classList.remove('btn-secondary');
            if (result.status == 'error') {
                abutton.classList.add('btn-danger');

                abar = document.getElementById('cnt' + archive.name + 2)
                abarwidth = parseFloat(abar.style.width.slice(0,-1)) + part * 100;
                abar.style.width = (abarwidth).toString() + '%';
            }
            else {
                abutton.classList.add('btn-success');

                abar = document.getElementById('cnt' + archive.name + 3)
                abarwidth = parseFloat(abar.style.width.slice(0,-1)) + part * 100;
                abar.style.width = (abarwidth).toString() + '%';
            }
            readybar = document.getElementById('cnt' + archive.name + 1);
            readybarwidth = parseFloat(readybar.style.width.slice(0,-1))-part * 100;
            readybar.style.width = (readybarwidth).toString() + '%';
            
            abuttontext = document.getElementById(neuron_name + "_message") ; 
            abuttontext.innerHTML = result.message;

            neuronlink = document.getElementById(neuron_name + "_link") ;
            neuronlink.classList.remove('disabled');

            neuroningest = document.getElementById(neuron_name  + "_ingest") ;
            neuroningest.classList.add('disabled');
            
            anelem = document.getElementById(archive.name + "_button");
            anelem.classList.remove('btn-info');
            anelem.classList.add('btn-warning');
 
        }
    })
    
}

function ingestallneurons(archive_name) {
   // nData = dictArchiveNeuron["archive"];
    notFound = true;
    var anarchive; 
    ix = -1;
    while (notFound) {
        ix++
        notFound = activearchives[ix].name != archive_name;
    }
    anarchive = activearchives[ix]
    
    anelem = document.getElementById(archive_name +'_ibutton');
    anelem.classList.add('disabled');
    
    anelem = document.getElementById('cnt' + archive_name + 1);
    anelem.classList.add('progress-bar-animated');
    anelem.classList.add('progress-bar-striped');
    anelem = document.getElementById('cnt' + archive_name + 2);
    anelem.classList.add('progress-bar-animated');
    anelem.classList.add('progress-bar-striped');
    anelem = document.getElementById('cnt' + archive_name + 3);
    anelem.classList.add('progress-bar-animated');
    anelem.classList.add('progress-bar-striped');
    ingestneuron(anarchive,0);
    

}

function revertallneurons(archive_name) {
    $.ajax({
		url: 'http://127.0.0.1:5000/revertarchive/' + archive_name,
		error: function () {
			console.log("Error!");
		},
		success: function (result) {
            console.log(result)
            activearchives = JSON.parse(getarchives()).data
            document.querySelector("body > header").innerHTML = ""
            document.querySelector("body > main").innerHTML = ""
            
            createArchivePanel(activearchives)
            createDataPanel(activearchives)			
		},
		type: 'GET'
    }); 
    
}


function createDataPanel(archives){
    
    //dictArchiveNeuron = createArchiveNeuronDict(count, ingestioData);
    //dictArchiveCount = createArchiveCountDict(count, ingestioData);
    //keyCount = 0;
    //dictArchiveNeuron = sortOnKeys(dictArchiveNeuron);
    archives.forEach(archive => {
        var statarr = [0,0,0];
        var total = 0
        archive.neurons.forEach(neuron => {
            total++;
            switch (neuron.status) {
                case "error":
                    statarr[1]++;
                    break;
                case "read":
                    statarr[0]++;
                    break;
                case "ingested":
                    statarr[2]++;
                default:
                    break;
            }
        });
        if (total == 0) {
            total++
        } 
        
 //       for (var index = 0; index < neuronData.length; index++) {
   //         if (index == 0){
    
        if (["error", "ingested", "ready"].includes(archive.status)) {
            idisabled = 'disabled="true"'
        }
        else {
            idisabled = ""
        }
        
        var elm = 
        `<div class="progress">
        <div id="cnt${archive.name + 1}" class="progress-bar " role="progressbar" style="width:${statarr[0]/total*100}%;  background-color:grey">Read</div>
        <div id="cnt${archive.name + 2}" class="progress-bar bg-danger" role="progressbar" style="width:${statarr[1]/total*100}%;  background-color:grey">Error</div>
        <div id="cnt${archive.name + 3}" class="progress-bar bg-success" role="progressbar" style="width:${statarr[2]/total*100}%;  background-color:grey">Ingested</div>
        </div>
        <div class="card">
        <div class="card-header">
        <a data-toggle="collapse" href="#collapse${archive.name}"  class="" aria-expanded="true">${archive.name}</a>
        <h6>Link: <a target="_blank" href="${archive.link}">to archive&gt;&gt;</a></h6> 
        
        <button id="${archive.name}_ibutton" ${idisabled} class="btn btn-primary btn-sm" type="button" style="float:right; margin-top: -45px;" onclick="ingestallneurons('${archive.name}',dm)">Ingest Archive</button>
        <button id="${archive.name}_rbutton" class="btn btn-primary btn-sm" type="button" style="float:right; margin-right: 120px; margin-top: -45px;" onclick="revertallneurons('${archive.name}',dm)">Revert Archive</button>
        </div>
        <div id="collapse${archive.name}" class="panel-collapse collapse" style="">
        <div class="card-body">
        <ul class="list-group" id="group_${archive.name}" >
        <li class="list-group-item">`

        archive.neurons.forEach(neuron => {
            switch (neuron.status) {
                case 'read':
                    btnclass = 'btn-secondary'
                    idisabled = "" 
                    ldisabled = "disabled"
                    break;
                case 'error':
                    btnclass = 'btn-danger'
                    idisabled = ""
                    ldisabled = "disabled"
                    break;
                case 'ingested':
                    btnclass = 'btn-success'
                    idisabled = "disabled"
                    ldisabled = ""
                    break;
                default:
                    btnclass = 'btn-secondary'
                    idisabled = ""
                    ldisabled = "disabled"
                    break;
            }
            elm += `
            <div class="btn-group">
            <button id="${neuron.neuron_name}_button" type="button" class="btn ${btnclass} dropdown-toggle m-1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">${neuron.neuron_name}</button>
            <div class="dropdown-menu p-4" style="max-width: 200px;">
            <button id="${neuron.neuron_name}_ingest"  class="dropdown-item ${idisabled}" onclick="ingestwrap('${neuron.neuron_name}','${neuron.archive}')" type="button">Ingest neuron</button>
            <a target="_blank" id="${neuron.neuron_name}_link" class="dropdown-item ${ldisabled}" href="http://cng.gmu.edu:8080/neuroMorphoDev/neuron_info.jsp?neuron_name=${neuron.neuron_name}" >Neuron link </a>
            <div class="dropdown-divider"></div>
            <h6 class="dropdown-header">Status</h6>
            <p class="dropdown-item disabled" id="${neuron.neuron_name}_message">
                ${neuron.message}
            </p>
            </div>
            </div>
            `;
        });
        elm += 
        `
        </li>
        </ul>
        </div>
        </div>`

        $(elm).appendTo(".container");

            
    });
}

function getmessage(message) {
    if (message === null) {
        return ""
    }
    else {
        return message
    }
    
}





function getIngest(status) {
    if (status == 2 || status == 5) {
        return '';
    }
    else {
        return 'disabled="true"';
    }
}

function getDisabled(status,pos) {
    if (status == pos) {
        return '';
    }
    else {
        return 'disabled="true"';
    }
}

$('#start_button').on('click', function () {

	var iterations = 100000;

	progressbar.progress_max = iterations;


    var i = 0;
        
    (function loop() {

        i++;
        if (iterations % i === 100) {
    	    progressbar.set(i); //only updates the progressbar         
        }   
        
        if (i < iterations) {
            setTimeout(loop, 0);
        }
        
    })();

});




