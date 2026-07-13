/*
==========================================
Tech Skills Hub Website
Founder: Funsho Gbenga Adebayo
Version: 1.0
==========================================
*/

document.addEventListener("DOMContentLoaded", function () {

    // ===========================
    // Smooth Navigation Highlight
    // ===========================

    const sections = document.querySelectorAll("section");
    const navLinks = document.querySelectorAll("nav a");

    window.addEventListener("scroll", () => {

        let current = "";

        sections.forEach(section => {

            const sectionTop = section.offsetTop - 120;
            const sectionHeight = section.clientHeight;

            if (pageYOffset >= sectionTop) {
                current = section.getAttribute("id");
            }

        });

        navLinks.forEach(link => {

            link.classList.remove("active");

            if (link.getAttribute("href") === "#" + current) {
                link.classList.add("active");
            }

        });

    });

    // ===========================
    // Scroll To Top Button
    // ===========================

    const button = document.createElement("button");

    button.innerHTML = "↑";

    button.id = "topBtn";

    document.body.appendChild(button);

    button.style.position = "fixed";
    button.style.bottom = "20px";
    button.style.right = "20px";
    button.style.display = "none";
    button.style.padding = "12px 18px";
    button.style.fontSize = "18px";
    button.style.border = "none";
    button.style.borderRadius = "50%";
    button.style.cursor = "pointer";
    button.style.background = "#1565c0";
    button.style.color = "#fff";
    button.style.boxShadow = "0 4px 10px rgba(0,0,0,.3)";

    window.addEventListener("scroll", () => {

        if (window.scrollY > 400) {
            button.style.display = "block";
        } else {
            button.style.display = "none";
        }

    });

    button.addEventListener("click", () => {

        window.scrollTo({

            top: 0,
            behavior: "smooth"

        });

    });

    // ===========================
    // Footer Year
    // ===========================

    const footerYear = document.getElementById("year");

    if (footerYear) {
        footerYear.textContent = new Date().getFullYear();
    }

    // ===========================
    // Welcome Message
    // ===========================

    console.log("Welcome to Tech Skills Hub");

});
