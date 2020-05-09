$(document).ready(function() {
    console.log( "Document Loaded!" );
    retrieveIngestionData();
    searchArchiveFilter();
});

function searchArchiveFilter(){
    $("#searchArchive").on("keyup", function() {
        var archiveFilter = $(this).val();
        console.log(archiveFilter);

        $(".archiveTitle").each(function () {
            $('.panel-collapse').collapse('hide');
            if (archiveFilter == "") {
                $(this).parent().css("visibility", "visible");
                $(this).parent().fadeIn();
            } else if ($(this).text().search(new RegExp(archiveFilter, "i")) < 0) {
                $(this).parent().css("visibility", "hidden");
                $(this).parent().fadeOut();
            } else {
                $(this).parent().css("visibility", "visible");
                $(this).parent().fadeIn();
            }
        });
    });
}

function retrieveIngestionData() {
    $(".loading").show();
	 $.ajax({
		url: 'http://127.0.0.1:5000/ingestionUI',
		error: function () {
			console.log("Error!");
		},
		success: function (result) {
            console.log(result)
			createDataPanel(result.count, result.data)			
		},
		type: 'GET'
    }); 
    $(".loading").hide();
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
        
        for (var index = 0; index < neuronData.length; index++) {
            if (index == 0){
                var elm = '<div class="card"> ' +
                '<div class="card-header"> ' +
                '<a data-toggle="collapse" href="#collapse' + keyCount.toString() + '"  class="archiveTitle" aria-expanded="true">' + neuronData[index]["archive"] + '</a> ' +
                '<h6>Ready: ' + countData[2] +', Not Ready: ' + countData[1] +', Success: ' + countData[3] +', Warning: ' + countData[4] +', Error: ' + countData[5] +'</h6> ' +
                '<button class="btn btn-primary btn-sm" type="button" style="float:right;margin-top: -45px;" onclick="ingestarchive(\'' + neuronData[index]["archive"]  + '\')">Ingest Archive</button>' +
                '</div>' +
                '<div id="collapse' + keyCount.toString() +'" class="panel-collapse collapse" style=""> ' +
                '<div class="card-body">' +
                '<ul class="list-group" id="group_' + neuronData[index]["archive"] + '" >' +
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
                '</div>';
                $(elm).appendTo(".container");
            }
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
            }
        }
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

//dict = sortOnKeys(dict);

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

function ingestneuron(neuron_name) {
    $(".loading").show();
    console.log('Ingesting neuron: ' + neuron_name)
    var payload = {};
    payload['name'] = neuron_name;
    $.ajax({
        url: 'http://127.0.0.1:5000/ingestneuron',
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
    $(".loading").hide();
}

function ingestarchive(archive_name) {
    $(".loading").show();
    console.log('Ingesting archive: ' + archive_name)
    var payload = {};
    payload['archive'] = archive_name;
    $.ajax({
        url: 'http://127.0.0.1:5000/ingestarchive',
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
    $(".loading").hide();
}