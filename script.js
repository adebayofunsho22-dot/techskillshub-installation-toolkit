/*
==========================================
Tech Skills Hub
Professional Installation Services
Founder: Funsho Gbenga Adebayo
==========================================
*/

document.addEventListener("DOMContentLoaded", function () {

    console.log("Welcome to Tech Skills Hub");

    // Smooth scrolling for navigation links
    const links = document.querySelectorAll("nav a");

    links.forEach(link => {
        link.addEventListener("click", function (e) {

            const targetId = this.getAttribute("href");

            if (targetId.startsWith("#")) {

                e.preventDefault();

                const target = document.querySelector(targetId);

                if (target) {
                    target.scrollIntoView({
                        behavior: "smooth"
                    });
                }

            }

        });
    });

    // Highlight active navigation item
    const sections = document.querySelectorAll("section");

    window.addEventListener("scroll", function () {

        let current = "";

        sections.forEach(section => {

            const sectionTop = section.offsetTop - 120;
            const sectionHeight = section.clientHeight;

            if (pageYOffset >= sectionTop) {
                current = section.getAttribute("id");
            }

        });

        links.forEach(link => {

            link.classList.remove("active");

            if (link.getAttribute("href") === "#" + current) {
                link.classList.add("active");
            }

        });

    });

    // Navigation shadow while scrolling
    const nav = document.querySelector("nav");

    window.addEventListener("scroll", function () {

        if (window.scrollY > 30) {

            nav.style.boxShadow =
                "0 6px 20px rgba(0,0,0,0.15)";

        } else {

            nav.style.boxShadow =
                "0 2px 10px rgba(0,0,0,0.1)";

        }

    });

});

/*
==========================================
Future Features
==========================================

✔ Contact Form Validation
✔ Request a Quotation
✔ WhatsApp Chat Button
✔ Installation Booking
✔ Portfolio Gallery
✔ Dark Mode
✔ Client Dashboard

*/
