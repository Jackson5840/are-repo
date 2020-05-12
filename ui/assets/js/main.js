var activearchives
var loadcount
var ingestcount
var neur

$(document).ready(function() {
    console.log( "Document Loaded!" );
    getarchives();
});

function getarchives() {
    //get archives available - called on load
    $.ajax({
       url: 'http://127.0.0.1:5000/getarchives',
       error: function () {
           console.log("Error!");
       },
       success: function (result) {
           console.log(result)
           activearchives= result.data
           createArchivePanel(result.data)			
       },
       type: 'GET'
   });
    
}

function readarchives() {
    // read available archives - on clicking "read archives"

    part = 100/activearchives.length
    loadcount = 0;
    abutton = document.getElementById("read_button");
    abutton.classList.add('disabled');
    activearchives.forEach(element => {
        
        $.ajax({
        url: 'http://127.0.0.1:5000/readarchive/' + element,
        error: function () {
            console.log("Error!");
        },
        success: function (result) {
            console.log(result)
            loadcount++
            if (result.status == 'error') {
                abutton = document.getElementById(element + "_button")
                abutton.classList.remove('btn-secondary')
                abutton.classList.add('btn-danger')
                abutton = document.getElementById("read_button")
                abutton.classList.add('enabled')
                          
            }
            else {
                abutton = document.getElementById(element + "_button")
                abutton.classList.remove('btn-secondary')
                abutton.classList.add('btn-success')
                

            }
            abuttontext = document.getElementById(element + "_message")  
            abuttontext.innerHTML = result.message
            console.log(Math.round(loadcount * part))
            if (Math.round(loadcount * part) == 100) { 
                anelem = document.getElementById("archivebar")
                anelem.classList.remove('progress-bar-animated')
                anelem.classList.remove('progress-bar-striped')
                retrieveIngestionData()
            }
            document.getElementById("archivebar").style.width = (loadcount * part).toString() + '%';  			
        },
        type: 'GET'
        }); 
    });
}



function retrieveIngestionData() {
    //  reading available archives - on clicking read archives
    console.log('calling')
	 $.ajax({
		url: 'http://127.0.0.1:5000/getui',
		error: function () {
			console.log("Error!");
		},
		success: function (result) {
            console.log(result)
			createDataPanel(result.count, result.data)			
		},
		type: 'GET'
	}); 
}

function clearcontainer() {
    
}

function createArchivePanel(archives) {
    pcontent =
    `<div class="card">
        <div class="card" style="width: 100%;">
        <div class="card-body">
        <h5 class="card-title">Available archives</h5>
        <div class="bd-example">`
    archives.forEach(element => {
        pcontent += `
        <div class="btn-group">
        <button id="${element}_button" type="button" class="btn btn-secondary dropdown-toggle m-1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">${element}</button>
        <div class="dropdown-menu p-4 text-muted" style="max-width: 200px;">
        <p id="${element}_message">
            Ready for reading.
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


function ingestneuron(neuron_name,archive,nData,nextid=-1) {
    
    console.log('Ingesting neuron: ' + neuron_name);
    $.ajax({
        url: 'http://127.0.0.1:5000/ingestneuron/' + neuron_name,
        error: function () {
            console.log("Error!");
        },
        type: 'GET',
        success: function(result) {
            console.log(result);
            ingestcount++;
            part = 1 / nData.length;
            abutton = document.getElementById(neuron_name + "_button");
            abutton.classList.remove('btn-secondary');
            if (result.status == 'error') {
                abutton.classList.add('btn-danger');
                abar = document.getElementById('cnt' + archive + 5)
                abarwidth = parseFloat(abar.style.width.slice(0,-1)) + part * 100;
                abar.style.width = (abarwidth).toString() + '%';
                          
            }
            else {
                abutton.classList.add('btn-success');
                abar = document.getElementById('cnt' + archive + 3)
                abarwidth = parseFloat(abar.style.width.slice(0,-1)) + part * 100;
                abar.style.width = (abarwidth).toString() + '%';
            }
            readybar = document.getElementById('cnt' + archive + 2);
            readybarwidth = parseFloat(readybar.style.width.slice(0,-1))-part * 100;
            readybar.style.width = (readybarwidth).toString() + '%';
            abuttontext = document.getElementById(neuron_name + "_message") ; 
            abuttontext.innerHTML = result.message;
            neuronlink = document.getElementById(neuron_name + "_link") ;
            neuronlink.classList.remove('disabled');
            console.log(Math.round(part))
            if (Math.round(ingestcount*part*100) == 100) { 
                anelem = document.getElementById('cnt' + archive + 2);
                anelem.classList.remove('progress-bar-animated');
                anelem.classList.remove('progress-bar-striped');
                
                anelem = document.getElementById('cnt' + archive + 3);
                anelem.classList.remove('progress-bar-animated');
                anelem.classList.remove('progress-bar-striped');
                //readybarwidth = parseFloat(anelem.style.width.slice(0,-1))-part*100;
                readybar.style.width = '0%';

                anelem = document.getElementById('cnt' + archive + 5);
                anelem.classList.remove('progress-bar-animated');
                anelem.classList.remove('progress-bar-striped');
            }
            
            if (nextid >= 0) {
                ingestneuron(nData[nextid]["neuron_name"],archive,nData,nextid-1);
            }
        }
    });
    
}
function ingestallneurons(archive,nData) {
    ingestcount = 0;
   // nData = dictArchiveNeuron["archive"];
    ndlix = nData.length - 1;
    anelem = document.getElementById(archive +'_ibutton');
    anelem.classList.add('disabled');
    
    anelem = document.getElementById('cnt' + archive + 2);
    anelem.classList.add('progress-bar-animated');
    anelem.classList.add('progress-bar-striped');
    anelem = document.getElementById('cnt' + archive + 3);
    anelem.classList.add('progress-bar-animated');
    anelem.classList.add('progress-bar-striped');
    anelem = document.getElementById('cnt' + archive + 5);
    anelem.classList.add('progress-bar-animated');
    anelem.classList.add('progress-bar-striped');
    ingestneuron(nData[ndlix]["neuron_name"],archive,nData,ndlix-1);

}

function createDataPanel(count, ingestioData){
    
    console.log("Ready to Create!")
    console.log("Total Count - " + count.toString())
    dictArchiveNeuron = createArchiveNeuronDict(count, ingestioData);
    dictArchiveCount = createArchiveCountDict(count, ingestioData);
    keyCount = 0;
    dictArchiveNeuron = sortOnKeys(dictArchiveNeuron);
    for (archiveKey in dictArchiveNeuron){
        neuronData = dictArchiveNeuron[archiveKey]
        countData = dictArchiveCount[archiveKey]
        
 //       for (var index = 0; index < neuronData.length; index++) {
   //         if (index == 0){
        var total = countData[1] + countData[2] + countData[3] + countData[4] + countData[5];
        var elm = 
        '<div class="progress">' +
        '<div id="cnt'+ neuronData[0]["archive"] + 1 + '" class="progress-bar " role="progressbar" style="width:' + countData[1]/total * 100 + '%;  background-color:grey">Not ready</div>' +
        '<div id="cnt'+ neuronData[0]["archive"] + 2 + '" class="progress-bar bg-info" role="progressbar" style="width:' + countData[2]/total *100 + '%">Ready</div>' +
        '<div id="cnt'+ neuronData[0]["archive"] + 3 + '" class="progress-bar bg-success" role="progressbar" style="width:' + countData[3]/total + ';  background-color:green">Success</div>' +
        '<div id="cnt'+ neuronData[0]["archive"] + 4 + '" class="progress-bar bg-warning" role="progressbar" style="width:' + countData[4]/total + ';  background-color:orange"> Warning</div>' +
        '<div id="cnt'+ neuronData[0]["archive"] + 5 + '" class="progress-bar bg-danger" role="progressbar" style="width:' + countData[5]/total + ';  background-color:red">Error</div>' +
        '</div>'+
        '<div class="card"> ' +
        '<div class="card-header"> ' +
        '<a data-toggle="collapse" href="#collapse' + keyCount.toString() + '"  class="" aria-expanded="true">' + neuronData[0]["archive"] + '</a> ' +
        `<h6>Link: <a href="http://cng.gmu.edu:8080/neuroMorphoDev/NeuroMorpho_ArchiveLinkout.jsp?ARCHIVE=${archiveKey}&DATE=${todayDate = new Date().toISOString().slice(0,10)}">to archive&gt;&gt;</a></h6> 
        
        <button id="${neuronData[0]["archive"]}_ibutton" class="btn btn-primary btn-sm" type="button" style="float:right;margin-top: -45px;" onclick="ingestallneurons('${neuronData[0]["archive"]}',dictArchiveNeuron['${neuronData[0]["archive"]}'])">Ingest Archive</button>
        </div>
        <div id="collapse${keyCount.toString()}" class="panel-collapse collapse" style="">
        <div class="card-body">
        <ul class="list-group" id="group_${neuronData[0]["archive"]}" >
        <li class="list-group-item">`
/* 
        elm += `
        <li class="list-group-item">
        <div class="btn-group">
        <button id="${neuronData[0]["neuron_name"]}_button" type="button" class="btn btn-secondary dropdown-toggle m-1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">${neuronData[0]["neuron_name"]}</button>
        <div class="dropdown-menu p-4" style="max-width: 200px;">
        <button class="dropdown-item" type="button">Ingest neuron</button>
        <div class="dropdown-divider"></div>
        <h6 class="dropdown-header">Status</h6>
        <p class="dropdown-item disabled" id="${neuronData[0]["neuron_name"]}_message">
            Ready for ingestion.
        </p>
        </div>
        </div>
        </li>`;
                 */

        neuronData.slice(0).forEach(element => {
            elm += `
            <div class="btn-group">
            <button id="${element["neuron_name"]}_button" type="button" class="btn btn-secondary dropdown-toggle m-1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">${element["neuron_name"]}</button>
            <div class="dropdown-menu p-4" style="max-width: 200px;">
            <button class="dropdown-item" onclick="ingestneuron('${element["neuron_name"]}','${element["archive"]}',[neuronData[0]])" type="button">Ingest neuron</button>
            <a target="_blank" id="${element["neuron_name"]}_link" class="dropdown-item disabled" href="http://cng.gmu.edu:8080/neuroMorphoDev/neuron_info.jsp?neuron_name=${element['neuron_name']}" >Neuron link </a>
            <div class="dropdown-divider"></div>
            <h6 class="dropdown-header">Status</h6>
            <p class="dropdown-item disabled" id="${element["neuron_name"]}_message">
                Ready for ingestion.
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
/* 
                elm +=
                '<li class="list-group-item">' +
                '<h6>'+ neuronData[index]["neuron_name"] + '</h6> '+
                '<button class="btn btn-primary btn-sm" type="button" style="float:right;margin-top: -28px;" ' + getDisabled(neuronData[index]["status"],2) + ' onclick="ingestneuron(\'' + neuronData[index]["neuron_name"]  + '\')">Ingest</button>' +
                
                '<button class="btn btn-dark btn-sm" type="button" style="float:left;margin-top: -4px;" ' + getDisabled(neuronData[index]["status"],1) + ' data-toggle="collapse" data-target="#error_' + neuronData[index]["archive"] + "_" + neuronData[index]["neuron_name"] + '">Not Ready</button>' +
                '<button class="btn btn-primary btn-sm" type="button" style="float:left;margin-top: -4px;" ' + getDisabled(neuronData[index]["status"],2) + '>Ready</button>' +
                '<button class="btn btn-success btn-sm" type="button" style="float:left;margin-top: -4px;" ' + getDisabled(neuronData[index]["status"],3) + '>Success</button>' +
                '<button class="btn btn-warning btn-sm" data-toggle="collapse" data-target="#error_'+ neuronData[index]["archive"] + "_" + neuronData[index]["neuron_name"] + '"  type="button" style="float:left;margin-top: -4px;" ' + getDisabled(neuronData[index]["status"],4) + '>Warning</button>' +
                '<button class="btn btn-danger btn-sm" data-toggle="collapse" data-target="#error_' + neuronData[index]["archive"] + "_" + neuronData[index]["neuron_name"] + '"  type="button" style="float:left;margin-top: -4px;" ' + getDisabled(neuronData[index]["status"],5) + '>Error</button>' +
                ' <div id="error_' + neuronData[index]["archive"] + "_" + neuronData[index]["neuron_name"] + '" class="collapse show" style="margin-top: 40px;">' + getmessage(neuronData[index]["premessage"]) + getmessage(neuronData[index]["errors"]) +
                '</div>' +
                '</li>' +
                '</ul>' +
                '</div>' +
                '</div>' +
                '</div>'; */
        $(elm).appendTo(".container");
/*             }
            else {
                listItem ='<li class="list-group-item">' +
                        '<h6>'+ neuronData[index]["neuron_name"] + '</h6> '+
                        '<button class="btn btn-primary btn-sm" type="button" style="float:right;margin-top: -28px;" ' + getIngest(neuronData[index]["status"]) + ' onclick="ingestneuron(\'' + neuronData[index]["neuron_name"]  + '\')">Ingest</button>' +
                        '<button class="btn btn-dark btn-sm" type="button" style="float:left;margin-top: -4px;" data-toggle="collapse" ' + getDisabled(neuronData[index]["status"],1) + ' data-target="#error_' + neuronData[index]["archive"] + "_" + neuronData[index]["neuron_name"] + '">Not Ready</button>' +
                        '<button class="btn btn-primary btn-sm" type="button" style="float:left;margin-top: -4px;" ' + getDisabled(neuronData[index]["status"],2) + '>Ready</button>' +
                        '<button class="btn btn-success btn-sm" type="button" style="float:left;margin-top: -4px;" ' + getDisabled(neuronData[index]["status"],3) + '>Success</button>' +
                        '<button class="btn btn-warning btn-sm" data-toggle="collapse" data-target="#error_'+ neuronData[index]["archive"] + "_" + neuronData[index]["neuron_name"] + '"  type="button" style="float:left;margin-top: -4px;" ' + getDisabled(neuronData[index]["status"],4) + '>Warning</button>' +
                        '<button class="btn btn-danger btn-sm" data-toggle="collapse" data-target="#error_' + neuronData[index]["archive"] + "_" + neuronData[index]["neuron_name"] + '"  type="button" style="float:left;margin-top: -4px;" ' + getDisabled(neuronData[index]["status"],5) + '>Error</button>' +
                        ' <div id="error_' + neuronData[index]["archive"] + "_" + neuronData[index]["neuron_name"] + '" class="collapse show" style="margin-top: 40px;"> ' + getmessage(neuronData[index]["premessage"]) + getmessage(neuronData[index]["errors"]) +
                        '</div>' +
                        '</li>';
                $(listItem).appendTo('#group_' + neuronData[index]["archive"]);
            } */
        keyCount = keyCount + 1;
    }
}

function getmessage(message) {
    if (message === null) {
        return ""
    }
    else {
        return message
    }
    
}

function sortOnKeys(dict) {

    var sorted = [];
    for(var key in dict) {
        sorted[sorted.length] = key;
    }
    sorted.sort();

    var tempDict = {};
    for(var i = 0; i < sorted.length; i++) {
        tempDict[sorted[i]] = dict[sorted[i]];
    }

    return tempDict;
}

function createArchiveNeuronDict(totalCount, ingestioData){
    var dictArchiveNeuron = {};
    for (var indexVal = 0; indexVal < ingestioData.length; indexVal++) {
        if (dictArchiveNeuron[ingestioData[indexVal]["archive"]] === undefined){
            dictArchiveNeuron[ingestioData[indexVal]["archive"]] = [ingestioData[indexVal]]
        }
        else{
            dictArchiveNeuron[ingestioData[indexVal]["archive"]].push(ingestioData[indexVal])
        }
    }
    
    console.log("Archive Dictionary Check!")
    console.log(dictArchiveNeuron)
    return dictArchiveNeuron;
}

function createArchiveCountDict(totalCount, ingestioData){
    var dictArchiveCount = {};

    for (var indexVal = 0; indexVal < ingestioData.length; indexVal++) {
        if (dictArchiveCount[ingestioData[indexVal]["archive"]] === undefined){
            dictArchiveCount[ingestioData[indexVal]["archive"]] = {}
            for(var ix = 0; ix < 6; ix++) {
                dictArchiveCount[ingestioData[indexVal]["archive"]][ix] = 0
            }


            dictArchiveCount[ingestioData[indexVal]["archive"]][ingestioData[indexVal]["status"]] = 1
        }
        else{
            if (dictArchiveCount[ingestioData[indexVal]["archive"]][ingestioData[indexVal]["status"]]  === undefined){
                dictArchiveCount[ingestioData[indexVal]["archive"]][ingestioData[indexVal]["status"]] = 1
            }
            else {
                dictArchiveCount[ingestioData[indexVal]["archive"]][ingestioData[indexVal]["status"]]++
            }
        }
    }
    
    console.log("Archive Count Check!")
    console.log(dictArchiveCount)
    return dictArchiveCount;
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





function ingestarchive(archive_name) {
    console.log('Ingesting archive: ' + archive_name)
    var payload = {};
    payload['archive'] = archive_name;
    payload['status'] = 0;
    // $.ajax({
    //     url: 'http://127.0.0.1:5000/ingestarchive',
	// 	error: function () {
	// 		console.log("Error!");
	// 	},
    //     type: 'POST',
    //     contentType: 'application/json; charset=utf-8',
    //     data: JSON.stringify(payload),
    //     dataType: 'text',
    //     success: function(result) {
    //         console.log(result);
    //     }
    // });
    $.ajax({
        url: 'http://127.0.0.1:5000/setstatus/',
		error: function () {
			console.log("Error!");
		},
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify(payload),
        dataType: 'text',
        success: function(result) {
            console.log(result);
        }
    });
     
}