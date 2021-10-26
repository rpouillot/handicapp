
shinyUI({
  fluidPage(theme = shinytheme("readable"),
            tags$head(
              HTML('<!-- Global site tag (gtag.js) - Google Analytics -->'),
              HTML('<script async src="https://www.googletagmanager.com/gtag/js?id=UA-117763910-1"></script>' ),
              includeScript("www/GoogleScript.js")
            ),
            
            titlePanel(
              windowTitle="HandicApp",
              title=HTML('<h1>Une carte interactive des établissements marqués &#171;Tourisme et Handicap&#187; en France.</h1>')
            ), #End Title Panel
            fluidRow(
              column(width=12,
                     HTML('Ce site exploite la base de données publique &#171;Tourisme et Handicap&#187; mise à disposition 
                          <a href="http://www.data.gouv.fr/fr/datasets/marque-detat-tourisme-handicap" target="_blank">ici</a>.<hr>')
                     )
              ),
            tabsetPanel(
              tabPanel("Carte et base de données",
                       fluidRow(
                         column(width=6,
                                h4("1. Sélectionnez un (ou plusieurs) handicap(s):"),
                                helpText("Si plusieurs handicaps sont sélectionnés: le site proposera les établissemements aux normes pour tous les handicaps selectionnés."),
                                fluidRow(
                                  column(width=1, HTML('<img src="pictomoteur.jpg" height="25" width="25"/>')),
                                  column(width=3, checkboxInput("Moteur", "Moteur",TRUE)),
                                  column(width=1, HTML('<img src="pictoauditif.jpg" height="25" width="25"/>')),
                                  column(width=3, checkboxInput("Auditif", "Auditif",FALSE))
                                ),
                                fluidRow(
                                  column(width=1, HTML('<img src="pictomental.jpg" height="25" width="25"/>')),
                                  column(width=3, checkboxInput("Mental", "Mental",FALSE)),
                                  column(width=1, HTML('<img src="pictovisuel.jpg" height="25" width="25"/>')),
                                  column(width=3, checkboxInput("Visuel", "Visuel",FALSE))
                                )
                                
                         )
                       ),
                       sidebarLayout(
                         
                         sidebarPanel(width=2,
                                      fluidRow(
                                        h4("2. Selectionnez un (ou plusieurs) type d'établissement:"),
                                        checkboxGroupInput("activite", NULL,
                                                           Activite,
                                                           selected= c("Chambre d'hôtes","Hébergement insolite","Hôtel","Hôtel-restaurant")
                                        )
                                      )
                         ),
                         
                         mainPanel(
                           fluidRow(
                             column(width=12,
                                    h4("3. Zoomez sur la zone d'intérêt, et cliquez sur la marque pour obtenir des détails sur un établissement:"),
                                    helpText("Cliquez sur la carte pour la déplacer.
                                             Localisation fournie uniquement à titre indicatif.
                                             Les charactéristiques (adresse, téléphone, ...) des établissements sont également précisées 
                                             dans le tableau sous la carte.")
                                    )
                                    ),
                           fluidRow(
                             column(width=12,
                                    textOutput("NbRecords"),
                                    leafletOutput("map",height=800)
                             )
                           )
                                    )
                         ),
                       fluidRow(
                         column(width=12,
                                h4("4. Coordonnées et charactéristiques des établissements visibles sur la carte:")
                         )
                       ),
                       fluidRow(
                         column(width=12,
                                DTOutput("TableSelection")
                         )
                       ),
                       fluidRow(
                         column(width=12,
                                br(),
                                hr(),
#                                HTML("Application Shiny développée par <a href=mailto:handicappowner@gmail.com>R. Pouillot</a>"),
                                hr()
                         )
                       )
                       
            ),
            tabPanel("Commentaires, Méthodes et Limites",
                     br(),
                     HTML('Les erreurs sur ce site sont des erreurs de la
                          base de données originale et l&#39auteur de l&#39application n&#39en est pas responsable. 
                          Les établissements ont été géolocalisés à partir de l&#39adresse avec des niveaux de précision
                          variables.'),
                     HTML('Nous recommandons (d&#39expérience) 
                          de toujours confirmer l&#39accessibilité des établissements avant de vous y rendre.</br></br>'), 
                     HTML("<cite>Tourisme & Handicap est l'unique marque d&#39Etat attribuée aux professionnels du 
                          tourisme qui oeuvrent en faveur de l'accessibilité pour tous. 
                          Elle a pour objectif d&#39apporter une information objective et homogène sur l&#39accessibilité des 
                          sites et des équipements touristiques. Tourisme & Handicap prend en compte les quatre familles 
                          de handicaps (auditif, mental, moteur et visuel) et vise à développer une offre touristique 
                          adaptée et intégrée à l&#39offre généraliste. Pour obtenir cette marque, le prestataire doit 
                          s'engager dans une démarche exigeante (critères précis) et vérifiée tous les 5 ans 
                          (visite d'évaluation).</cite>"),
                     HTML("<a href='http://www.entreprises.gouv.fr/marques-nationales-tourisme/mentions-legales-des-annuaires-des-marques-nationales-du-tourisme'> Voir les mentions légales.</a>"),
                     HTML("<br><br>Lamentablement, ce site n'est pas accessible aux personnes déficientes visuelles. L'auteur s'en excuse
                          et est prêt à recevoir tout conseil pour remédier à cet inconvénient.")
                     ), #End Panel
            tabPanel("Joindre l'auteur",
                     HTML('<br><br>Pour ajouter un établissement, corriger des informations, ou faire des compliments, merci d&#39envoyer un 
                          <a href=mailto:info@thesearemyapps.com>courriel</a></br></br>')
                     )
            
            )# End tabset Panel
                     ) #End Fluid Page
})