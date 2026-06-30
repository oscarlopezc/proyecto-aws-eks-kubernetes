async function consultarBackend() {

    const resultado = document.getElementById("resultado");

    try {

        const response = await fetch("http://localhost:8000/info");

        const data = await response.json();

        resultado.textContent = JSON.stringify(data, null, 2);

    }

    catch (error) {

        resultado.textContent = "No fue posible conectar con el Backend.";

    }

}