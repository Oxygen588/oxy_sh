$(document).ready(function(){

	window.addEventListener("message", function(event){

	
		$(".masini").html("<span class='symbol'></span>"+event.data.masini);
		$(".pret").html("<span class='symbol'>Vinde pentru</span>"+event.data.pret);
        $(".numemasina").html("<span class='symbol'>Nume masina: </span>"+event.data.numemasina);
        $(".pretoriginal").html("<span class='symbol'>Pret Original  </span> "+event.data.pretoriginal);
        
        
	});
  });


vehs  ={
    [1]: {data:{},nume:"M3 320d",brand:"BMW",hp:4210,topspeed:200,model:"t220",tipfrane:"bune",pret:50000,expt:"tractare",url:"https://cdn.discordapp.com/attachments/991069015021613066/998014267037077564/unknown.png"},
    [2]: {data:{},nume:"M3 3202dune",brand:"BMW2",hp:400,topspeed:200,model:"DUNE5",tipfrane:"bune",pret:50000,expt:"tractare",url:"https://cdn.discordapp.com/attachments/991069015021613066/998014267037077564/unknown.png"},
    [3]: {data:{},nume:"M3 32012d",brand:"BMW",hp:400,topspeed:200,model:"t20",tipfrane:"bune",pret:50000,expt:"tractare",url:"https://cdn.discordapp.com/attachments/991069015021613066/998014267037077564/unknown.png"},
    [4]: {data:{},nume:"M3 32024d",brand:"BMW",hp:400,topspeed:200,model:"t20",tipfrane:"bune",pret:50000,expt:"tractare",url:"https://cdn.discordapp.com/attachments/991069015021613066/998014267037077564/unknown.png"},
    [5]: {data:{},nume:"M3 32055d",brand:"BMW",hp:400,topspeed:200,model:"t20",tipfrane:"bune",pret:50000,expt:"tractare",url:"https://cdn.discordapp.com/attachments/991069015021613066/998014267037077564/unknown.png"},
}
paginacurrenta = 1

function makepages(){
    pan = `<button onclick="anpg()">Pagina anterioara.</button>`
    if (paginacurrenta == 1) {
        pan = "Prima pagina"
    }
    pan2 = `<button onclick="urpg()">Pagina urmatoarre.</button>`

 
    tosh = `
    <header>
    <h1> ${pan} </h1>
    <h1>${pan2} </h1>
</header>
<article>
    
    <h2 class="chapter-title">${vehs[paginacurrenta].brand} ${vehs[paginacurrenta].nume}</h2>
    <img src="${vehs[paginacurrenta].url}" width="400" height="250">
    <p>
        Numele masinei este ${vehs[paginacurrenta].nume}, are frane ${vehs[paginacurrenta].tipfrane}, prinde un top speed de ${vehs[paginacurrenta].topspeed}km/h, masina excelenta pentru ${vehs[paginacurrenta].expt}.
    </p>
    <p>
        <a style="color: red;" >${vehs[paginacurrenta].hp}HP</a>
        
    </p>
</br>
    <p>
        <p><button onclick="testdrrive('${vehs[paginacurrenta].model}')">Testeaza</button> masina!</p>
        <p><button  onclick="vezimasina('${vehs[paginacurrenta].model}','${vehs[paginacurrenta].pret}','${vehs[paginacurrenta].nume}')">Vezi</button> masina!</p>
        <p><button onclick="vezitotveh('${vehs}','${vehs[paginacurrenta].brand}')" >Vezi</button> toata gama masini bmw!</p>
        <p><button  >Cumpara</button> pentru ${vehs[paginacurrenta].pret}$</p>
    </p>


    
    <h2 class="chapter-title">${vehs[paginacurrenta+1].brand} ${vehs[paginacurrenta+1].nume}</h2>
    <img src="${vehs[paginacurrenta+1].url}" width="400" height="250">
    <p>
        Numele masinei este ${vehs[paginacurrenta+1].nume}, are frane ${vehs[paginacurrenta+1].tipfrane}, prinde un top speed de ${vehs[paginacurrenta+1].topspeed}km/h, masina excelenta pentru ${vehs[paginacurrenta].expt}.
    </p>
    <p>
        <a style="color: red;" >${vehs[paginacurrenta+1].hp}HP</a>
        
    </p>
</br>
    <p>
        <p><button onclick="testdrrive('${vehs[paginacurrenta+1].model}')">Testeaza</button> masina!</p>
        <p><button  onclick="vezimasina('${vehs[paginacurrenta+1].model}','${vehs[paginacurrenta+1].pret}','${vehs[paginacurrenta+1].nume}')">Vezi</button> masina!</p>
        <p><button onclick="vezitotveh('${vehs}','${vehs[paginacurrenta+1].brand}')" >Vezi</button> toata gama masini bmw!</p>
        <p><button  >Cumpara</button> pentru ${vehs[paginacurrenta+1].pret}$</p>
    </p>

</article>
<footer>
    <ol id="page-numbers">
        <li id="pgcur">${paginacurrenta}</li>
        <li id="pgcurp1">${paginacurrenta+1}</li>
    </ol>
</footer>
</section>`

    $(".open-book").html(tosh)
}
function urpg(){
    console.log("teete")
        paginacurrenta = paginacurrenta + 1
        makepages()
}
function anpg(){
    console.log("teete")
        paginacurrenta = paginacurrenta -1
        makepages()
}
function vezitotveh(totvehs,brandd){
    vv = JSON.stringify(vehs)
    console.log(vv)
    $.post('http://oxy_sh/viewallvehs', JSON.stringify({brand:brandd,vehs:vv}));
}

function testdrrive(veh){
    $.post('http://oxy_sh/TestDriveCallback', JSON.stringify({modelcar:veh}));
    console.log(veh)
}
vezimasina
function vezimasina(veh,p,n){
    $.post('http://oxy_sh/vezimasina', JSON.stringify({modelcar:veh,pret:p,nume:n}));
    console.log(veh)
}

$(function () {
    function display(bool) {
        if (bool) {
            
            $("#container").show();
            makepages()
        } else {
            $("#container").hide();
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        }
    })
    // if the person uses the escape key, it will exit the resource
    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('http://oxy_sh/exit', JSON.stringify({}));
            return
        }
    };
    
    $("#close").click(function () {
        $.post('http://oxy_sh/exit', JSON.stringify({}));
        return
    })
   
    $("#rasp1").click(function () {
        if (raspcorect == rasp1){
        $.post('http://oxy_sh/raspcorectmanule', JSON.stringify({}));
        return
        } else {
            $.post('http://oxy_sh/raspgresit', JSON.stringify({}));
            return
        }
    })
    $("#rasp2").click(function () {
        if (raspcorect == rasp2){
            $.post('http://oxy_sh/raspcorectmanule', JSON.stringify({}));
            return
            } else {
                $.post('http://oxy_sh/raspgresit', JSON.stringify({}));
                return
            }
    })
    $("#rasp3").click(function () {
        if (raspcorect == rasp3){
            $.post('http://oxy_sh/raspcorectmanule', JSON.stringify({}));
            return
            } else {
                $.post('http://oxy_sh/raspgresit', JSON.stringify({}));
                return
            }
    })
    $("#rasp4").click(function () {
        if (raspcorect == rasp4){
            $.post('http://oxy_sh/raspcorectmanule', JSON.stringify({}));
            return
            } else {
                $.post('http://oxy_sh/raspgresit', JSON.stringify({}));
                return
            }
    })

    //when the user clicks on the submit button, it will run
    $("#submit").click(function () {
        let inputValue = $("#input").val()
        if (inputValue.length >= 100) {
            $.post("http://oxy_sh/error", JSON.stringify({
                error: "Input was greater than 100"
            }))
            return
        } else if (!inputValue) {
            $.post("http://oxy_sh/error", JSON.stringify({
                error: "There was no value in the input field"
            }))
            return
        }
        // if there are no errors from above, we can send the data back to the original callback and hanndle it from there
        $.post('http://oxy_sh/main', JSON.stringify({
            text: inputValue,
        }));
        return;
    })
})



function raspuns() {
	$.post('http://oxy_sh/select', JSON.stringify({}));
}