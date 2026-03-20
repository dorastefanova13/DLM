BEGIN --flooring

    PRINT '    fill flooring'

    DECLARE @json NVARCHAR(MAX) = 
    N'
{"values":[
{"id":"0","name":[{"lang":"en","value":"1.013"},{"lang":"de","value":"1.013"}],"type":"9","active":true}
,{"id":"1","name":[{"lang":"en","value":"2K-LACK"},{"lang":"de","value":"2K-LACK"}],"type":"9","active":true}
,{"id":"2","name":[{"lang":"en","value":"3"},{"lang":"de","value":"3"}],"type":"10","active":true}
,{"id":"3","name":[{"lang":"en","value":"8-9/C"},{"lang":"de","value":"8-9/C"}],"type":"9","active":true}
,{"id":"4","name":[{"lang":"en","value":"?"},{"lang":"de","value":"?"}],"type":"9","active":true}
,{"id":"5","name":[{"lang":"en","value":"ANLAUFBESPRECHUNGSZIMMER"},{"lang":"de","value":"ANLAUFBESPRECHUNGSZIMMER"}],"type":"9","active":true}
,{"id":"6","name":[{"lang":"en","value":"ASPHALT"},{"lang":"de","value":"ASPHALT"}],"type":"9","active":true}
,{"id":"7","name":[{"lang":"en","value":"ASPHALT"},{"lang":"de","value":"ASPHALT"}],"type":"10","active":true}
,{"id":"8","name":[{"lang":"en","value":"ASPHALT BESCHICHTET"},{"lang":"de","value":"ASPHALT BESCHICHTET"}],"type":"9","active":true}
,{"id":"9","name":[{"lang":"en","value":"ASPHALT BESCHICHTET"},{"lang":"de","value":"ASPHALT BESCHICHTET"}],"type":"10","active":true}
,{"id":"10","name":[{"lang":"en","value":"ASPHALT VERSIEGELT"},{"lang":"de","value":"ASPHALT VERSIEGELT"}],"type":"9","active":true}
,{"id":"11","name":[{"lang":"en","value":"ASPHALT VERSIEGELT"},{"lang":"de","value":"ASPHALT VERSIEGELT"}],"type":"10","active":true}
,{"id":"12","name":[{"lang":"en","value":"BEHINDERTEN WC"},{"lang":"de","value":"BEHINDERTEN WC"}],"type":"9","active":true}
,{"id":"13","name":[{"lang":"en","value":"BESCHICHTET"},{"lang":"de","value":"BESCHICHTET"}],"type":"9","active":true}
,{"id":"14","name":[{"lang":"en","value":"BESCHICHTETER ASPHALT"},{"lang":"de","value":"BESCHICHTETER ASPHALT"}],"type":"9","active":true}
,{"id":"15","name":[{"lang":"en","value":"BESCHICHTUNG FAHRSTRASSE"},{"lang":"de","value":"BESCHICHTUNG FAHRSTRASSE"}],"type":"9","active":true}
,{"id":"16","name":[{"lang":"en","value":"BESCHICHTUNG FAHRSTRASSEN"},{"lang":"de","value":"BESCHICHTUNG FAHRSTRASSEN"}],"type":"9","active":true}
,{"id":"17","name":[{"lang":"en","value":"BESCHICHTUNG VERKEHRSWEG"},{"lang":"de","value":"BESCHICHTUNG VERKEHRSWEG"}],"type":"9","active":true}
,{"id":"18","name":[{"lang":"en","value":"BESPRECHUNG"},{"lang":"de","value":"BESPRECHUNG"}],"type":"9","active":true}
,{"id":"19","name":[{"lang":"en","value":"BESPRECHUNGSRAUM"},{"lang":"de","value":"BESPRECHUNGSRAUM"}],"type":"9","active":true}
,{"id":"20","name":[{"lang":"en","value":"BETON"},{"lang":"de","value":"BETON"}],"type":"9","active":true}
,{"id":"21","name":[{"lang":"en","value":"BETON"},{"lang":"de","value":"BETON"}],"type":"10","active":true}
,{"id":"22","name":[{"lang":"en","value":"BETON LACKIERT"},{"lang":"de","value":"BETON LACKIERT"}],"type":"9","active":true}
,{"id":"23","name":[{"lang":"en","value":"BETON ROH"},{"lang":"de","value":"BETON ROH"}],"type":"9","active":true}
,{"id":"24","name":[{"lang":"en","value":"BETON VERSIEGELT"},{"lang":"de","value":"BETON VERSIEGELT"}],"type":"9","active":true}
,{"id":"25","name":[{"lang":"en","value":"BETON VERSIEGELT"},{"lang":"de","value":"BETON VERSIEGELT"}],"type":"10","active":true}
,{"id":"26","name":[{"lang":"en","value":"BETON-LACKIERT"},{"lang":"de","value":"BETON-LACKIERT"}],"type":"9","active":true}
,{"id":"27","name":[{"lang":"en","value":"BETONBODEN"},{"lang":"de","value":"BETONBODEN"}],"type":"9","active":true}
,{"id":"28","name":[{"lang":"en","value":"BETONPLATTEN"},{"lang":"de","value":"BETONPLATTEN"}],"type":"9","active":true}
,{"id":"29","name":[{"lang":"en","value":"BETONPLATTEN"},{"lang":"de","value":"BETONPLATTEN"}],"type":"10","active":true}
,{"id":"30","name":[{"lang":"en","value":"BETONTREPPE"},{"lang":"de","value":"BETONTREPPE"}],"type":"9","active":true}
,{"id":"31","name":[{"lang":"en","value":"BETONWERKSTEIN"},{"lang":"de","value":"BETONWERKSTEIN"}],"type":"9","active":true}
,{"id":"32","name":[{"lang":"en","value":"BLECH"},{"lang":"de","value":"BLECH"}],"type":"9","active":true}
,{"id":"33","name":[{"lang":"en","value":"BODENPLATTEN"},{"lang":"de","value":"BODENPLATTEN"}],"type":"9","active":true}
,{"id":"34","name":[{"lang":"en","value":"BüRO  KUNST"},{"lang":"de","value":"BüRO  KUNST"}],"type":"9","active":true}
,{"id":"35","name":[{"lang":"en","value":"BüRO HART KUNST"},{"lang":"de","value":"BüRO HART KUNST"}],"type":"9","active":true}
,{"id":"36","name":[{"lang":"en","value":"BüRO TEXTIL"},{"lang":"de","value":"BüRO TEXTIL"}],"type":"9","active":true}
,{"id":"37","name":[{"lang":"en","value":"C/1 - J/2"},{"lang":"de","value":"C/1 - J/2"}],"type":"9","active":true}
,{"id":"38","name":[{"lang":"en","value":"CORIAN"},{"lang":"de","value":"CORIAN"}],"type":"9","active":true}
,{"id":"39","name":[{"lang":"en","value":"DAMEN WC"},{"lang":"de","value":"DAMEN WC"}],"type":"9","active":true}
,{"id":"40","name":[{"lang":"en","value":"DB"},{"lang":"de","value":"DB"}],"type":"9","active":true}
,{"id":"41","name":[{"lang":"en","value":"DOPPELBODEN"},{"lang":"de","value":"DOPPELBODEN"}],"type":"9","active":true}
,{"id":"42","name":[{"lang":"en","value":"DOPPELBODEN KAUTSCHUK"},{"lang":"de","value":"DOPPELBODEN KAUTSCHUK"}],"type":"9","active":true}
,{"id":"43","name":[{"lang":"en","value":"DOPPELBODEN NADELFILZ"},{"lang":"de","value":"DOPPELBODEN NADELFILZ"}],"type":"9","active":true}
,{"id":"44","name":[{"lang":"en","value":"DOPPELBODEN PVC"},{"lang":"de","value":"DOPPELBODEN PVC"}],"type":"9","active":true}
,{"id":"45","name":[{"lang":"en","value":"DOPPELBODEN TEPPICH"},{"lang":"de","value":"DOPPELBODEN TEPPICH"}],"type":"9","active":true}
,{"id":"46","name":[{"lang":"en","value":"DRUCKLUFTANLAGE"},{"lang":"de","value":"DRUCKLUFTANLAGE"}],"type":"9","active":true}
,{"id":"47","name":[{"lang":"en","value":"EDELSTAHL"},{"lang":"de","value":"EDELSTAHL"}],"type":"9","active":true}
,{"id":"48","name":[{"lang":"en","value":"ENTSTAUBUNG"},{"lang":"de","value":"ENTSTAUBUNG"}],"type":"9","active":true}
,{"id":"49","name":[{"lang":"en","value":"ESD"},{"lang":"de","value":"ESD"}],"type":"9","active":true}
,{"id":"50","name":[{"lang":"en","value":"ESD INDUSTRIE"},{"lang":"de","value":"ESD INDUSTRIE"}],"type":"9","active":true}
,{"id":"51","name":[{"lang":"en","value":"ESD WEISS"},{"lang":"de","value":"ESD WEISS"}],"type":"9","active":true}
,{"id":"52","name":[{"lang":"en","value":"ESD-BELAG WEISS"},{"lang":"de","value":"ESD-BELAG WEISS"}],"type":"9","active":true}
,{"id":"53","name":[{"lang":"en","value":"ESSENWäRMER"},{"lang":"de","value":"ESSENWäRMER"}],"type":"9","active":true}
,{"id":"54","name":[{"lang":"en","value":"ESTRICH"},{"lang":"de","value":"ESTRICH"}],"type":"9","active":true}
,{"id":"55","name":[{"lang":"en","value":"ESTRICH"},{"lang":"de","value":"ESTRICH"}],"type":"10","active":true}
,{"id":"56","name":[{"lang":"en","value":"ESTRICH VERSIEGELT"},{"lang":"de","value":"ESTRICH VERSIEGELT"}],"type":"9","active":true}
,{"id":"57","name":[{"lang":"en","value":"F/19"},{"lang":"de","value":"F/19"}],"type":"9","active":true}
,{"id":"58","name":[{"lang":"en","value":"FAHRSTR"},{"lang":"de","value":"FAHRSTR"}],"type":"9","active":true}
,{"id":"59","name":[{"lang":"en","value":"FAHRSTRASSE"},{"lang":"de","value":"FAHRSTRASSE"}],"type":"9","active":true}
,{"id":"60","name":[{"lang":"en","value":"FEINSTEINFLIESEN"},{"lang":"de","value":"FEINSTEINFLIESEN"}],"type":"9","active":true}
,{"id":"61","name":[{"lang":"en","value":"FEINSTEINZEUG"},{"lang":"de","value":"FEINSTEINZEUG"}],"type":"9","active":true}
,{"id":"62","name":[{"lang":"en","value":"FEINSTEINZEUG"},{"lang":"de","value":"FEINSTEINZEUG"}],"type":"10","active":true}
,{"id":"63","name":[{"lang":"en","value":"FEINSTEINZEUG 30/30"},{"lang":"de","value":"FEINSTEINZEUG 30/30"}],"type":"9","active":true}
,{"id":"64","name":[{"lang":"en","value":"FEINSTEINZEUGFLIESEN 30/30"},{"lang":"de","value":"FEINSTEINZEUGFLIESEN 30/30"}],"type":"9","active":true}
,{"id":"65","name":[{"lang":"en","value":"FLIESEN"},{"lang":"de","value":"FLIESEN"}],"type":"9","active":true}
,{"id":"66","name":[{"lang":"en","value":"FLIESEN"},{"lang":"de","value":"FLIESEN"}],"type":"10","active":true}
,{"id":"67","name":[{"lang":"en","value":"FLIESEN ROT"},{"lang":"de","value":"FLIESEN ROT"}],"type":"9","active":true}
,{"id":"68","name":[{"lang":"en","value":"FLIESEN/PVC"},{"lang":"de","value":"FLIESEN/PVC"}],"type":"9","active":true}
,{"id":"69","name":[{"lang":"en","value":"FLUR"},{"lang":"de","value":"FLUR"}],"type":"9","active":true}
,{"id":"70","name":[{"lang":"en","value":"FLUR  PVC"},{"lang":"de","value":"FLUR  PVC"}],"type":"9","active":true}
,{"id":"71","name":[{"lang":"en","value":"FLUR TEXTIL"},{"lang":"de","value":"FLUR TEXTIL"}],"type":"9","active":true}
,{"id":"72","name":[{"lang":"en","value":"FOERDERTECHNIK"},{"lang":"de","value":"FOERDERTECHNIK"}],"type":"9","active":true}
,{"id":"73","name":[{"lang":"en","value":"FUSSABSTREIFER"},{"lang":"de","value":"FUSSABSTREIFER"}],"type":"9","active":true}
,{"id":"74","name":[{"lang":"en","value":"FWT-ANT/APA"},{"lang":"de","value":"FWT-ANT/APA"}],"type":"9","active":true}
,{"id":"75","name":[{"lang":"en","value":"GEFLIEST"},{"lang":"de","value":"GEFLIEST"}],"type":"9","active":true}
,{"id":"76","name":[{"lang":"en","value":"GEFLIEßT/ METALL"},{"lang":"de","value":"GEFLIEßT/ METALL"}],"type":"9","active":true}
,{"id":"77","name":[{"lang":"en","value":"GEHWEGPLATTEN"},{"lang":"de","value":"GEHWEGPLATTEN"}],"type":"9","active":true}
,{"id":"78","name":[{"lang":"en","value":"GEHWEGPLATTEN"},{"lang":"de","value":"GEHWEGPLATTEN"}],"type":"10","active":true}
,{"id":"79","name":[{"lang":"en","value":"GESCHLIFFENER GRANIT"},{"lang":"de","value":"GESCHLIFFENER GRANIT"}],"type":"9","active":true}
,{"id":"80","name":[{"lang":"en","value":"GITTER"},{"lang":"de","value":"GITTER"}],"type":"9","active":true}
,{"id":"81","name":[{"lang":"en","value":"GITTERBODEN"},{"lang":"de","value":"GITTERBODEN"}],"type":"9","active":true}
,{"id":"82","name":[{"lang":"en","value":"GITTERBODEN"},{"lang":"de","value":"GITTERBODEN"}],"type":"10","active":true}
,{"id":"83","name":[{"lang":"en","value":"GITTEROST"},{"lang":"de","value":"GITTEROST"}],"type":"9","active":true}
,{"id":"84","name":[{"lang":"en","value":"GITTERROST"},{"lang":"de","value":"GITTERROST"}],"type":"9","active":true}
,{"id":"85","name":[{"lang":"en","value":"GITTERROST"},{"lang":"de","value":"GITTERROST"}],"type":"10","active":true}
,{"id":"86","name":[{"lang":"en","value":"GN-BEH."},{"lang":"de","value":"GN-BEH."}],"type":"9","active":true}
,{"id":"87","name":[{"lang":"en","value":"GRANIT"},{"lang":"de","value":"GRANIT"}],"type":"9","active":true}
,{"id":"88","name":[{"lang":"en","value":"GRANIT"},{"lang":"de","value":"GRANIT"}],"type":"10","active":true}
,{"id":"89","name":[{"lang":"en","value":"GRANIT FLIESEN"},{"lang":"de","value":"GRANIT FLIESEN"}],"type":"9","active":true}
,{"id":"90","name":[{"lang":"en","value":"GRANIT GESCHLIFFEN"},{"lang":"de","value":"GRANIT GESCHLIFFEN"}],"type":"9","active":true}
,{"id":"91","name":[{"lang":"en","value":"GTI-FLIESEN"},{"lang":"de","value":"GTI-FLIESEN"}],"type":"9","active":true}
,{"id":"92","name":[{"lang":"en","value":"GTI-FLIESEN PVC"},{"lang":"de","value":"GTI-FLIESEN PVC"}],"type":"9","active":true}
,{"id":"93","name":[{"lang":"en","value":"GUMMI"},{"lang":"de","value":"GUMMI"}],"type":"9","active":true}
,{"id":"94","name":[{"lang":"en","value":"GUMMI"},{"lang":"de","value":"GUMMI"}],"type":"10","active":true}
,{"id":"95","name":[{"lang":"en","value":"GUMMI UND FLIESEN"},{"lang":"de","value":"GUMMI UND FLIESEN"}],"type":"9","active":true}
,{"id":"96","name":[{"lang":"en","value":"GUMMIBELAG"},{"lang":"de","value":"GUMMIBELAG"}],"type":"9","active":true}
,{"id":"97","name":[{"lang":"en","value":"GUMMINOPPEN"},{"lang":"de","value":"GUMMINOPPEN"}],"type":"9","active":true}
,{"id":"98","name":[{"lang":"en","value":"GUMMINOPPEN-BODEN"},{"lang":"de","value":"GUMMINOPPEN-BODEN"}],"type":"9","active":true}
,{"id":"99","name":[{"lang":"en","value":"GUMMINOPPENBELAG"},{"lang":"de","value":"GUMMINOPPENBELAG"}],"type":"9","active":true}
,{"id":"100","name":[{"lang":"en","value":"GUMMISCHNITZELPLATTEN"},{"lang":"de","value":"GUMMISCHNITZELPLATTEN"}],"type":"9","active":true}
,{"id":"101","name":[{"lang":"en","value":"GUMMISCHNITZELPLATTEN"},{"lang":"de","value":"GUMMISCHNITZELPLATTEN"}],"type":"10","active":true}
,{"id":"102","name":[{"lang":"en","value":"HALLENFLAECHE"},{"lang":"de","value":"HALLENFLAECHE"}],"type":"9","active":true}
,{"id":"103","name":[{"lang":"en","value":"HANDWASCHPLATZ"},{"lang":"de","value":"HANDWASCHPLATZ"}],"type":"9","active":true}
,{"id":"104","name":[{"lang":"en","value":"HARD-INDUSTRIE"},{"lang":"de","value":"HARD-INDUSTRIE"}],"type":"9","active":true}
,{"id":"105","name":[{"lang":"en","value":"HARD-KUNST"},{"lang":"de","value":"HARD-KUNST"}],"type":"9","active":true}
,{"id":"106","name":[{"lang":"en","value":"HART"},{"lang":"de","value":"HART"}],"type":"9","active":true}
,{"id":"107","name":[{"lang":"en","value":"HART -IND"},{"lang":"de","value":"HART -IND"}],"type":"9","active":true}
,{"id":"108","name":[{"lang":"en","value":"HART-IND"},{"lang":"de","value":"HART-IND"}],"type":"9","active":true}
,{"id":"109","name":[{"lang":"en","value":"HART-IND MIT LäUFER"},{"lang":"de","value":"HART-IND MIT LäUFER"}],"type":"9","active":true}
,{"id":"110","name":[{"lang":"en","value":"HART-KUNST"},{"lang":"de","value":"HART-KUNST"}],"type":"9","active":true}
,{"id":"111","name":[{"lang":"en","value":"HARTBODEN"},{"lang":"de","value":"HARTBODEN"}],"type":"9","active":true}
,{"id":"112","name":[{"lang":"en","value":"HARTBODEN (HOLZBODEN)"},{"lang":"de","value":"HARTBODEN (HOLZBODEN)"}],"type":"9","active":true}
,{"id":"113","name":[{"lang":"en","value":"HARTBODEN U. LäUFER"},{"lang":"de","value":"HARTBODEN U. LäUFER"}],"type":"9","active":true}
,{"id":"114","name":[{"lang":"en","value":"HERREN WC"},{"lang":"de","value":"HERREN WC"}],"type":"9","active":true}
,{"id":"115","name":[{"lang":"en","value":"HEUGA FLOR"},{"lang":"de","value":"HEUGA FLOR"}],"type":"9","active":true}
,{"id":"116","name":[{"lang":"en","value":"HEUGA-FLIES"},{"lang":"de","value":"HEUGA-FLIES"}],"type":"9","active":true}
,{"id":"117","name":[{"lang":"en","value":"HEUGA-FLOR"},{"lang":"de","value":"HEUGA-FLOR"}],"type":"9","active":true}
,{"id":"118","name":[{"lang":"en","value":"HEUGA-FLÖR"},{"lang":"de","value":"HEUGA-FLÖR"}],"type":"9","active":true}
,{"id":"119","name":[{"lang":"en","value":"HOCHREGALANLAGE"},{"lang":"de","value":"HOCHREGALANLAGE"}],"type":"9","active":true}
,{"id":"120","name":[{"lang":"en","value":"HOLGA-FLOR"},{"lang":"de","value":"HOLGA-FLOR"}],"type":"9","active":true}
,{"id":"121","name":[{"lang":"en","value":"HOLZ"},{"lang":"de","value":"HOLZ"}],"type":"9","active":true}
,{"id":"122","name":[{"lang":"en","value":"HOLZ"},{"lang":"de","value":"HOLZ"}],"type":"10","active":true}
,{"id":"123","name":[{"lang":"en","value":"HOLZ LACKIERT"},{"lang":"de","value":"HOLZ LACKIERT"}],"type":"9","active":true}
,{"id":"124","name":[{"lang":"en","value":"HOLZ UNVERSIEGELT"},{"lang":"de","value":"HOLZ UNVERSIEGELT"}],"type":"9","active":true}
,{"id":"125","name":[{"lang":"en","value":"HOLZ UNVERSIEGELT"},{"lang":"de","value":"HOLZ UNVERSIEGELT"}],"type":"10","active":true}
,{"id":"126","name":[{"lang":"en","value":"HOLZ VERSIEGELT"},{"lang":"de","value":"HOLZ VERSIEGELT"}],"type":"9","active":true}
,{"id":"127","name":[{"lang":"en","value":"HOLZ/ Z.T.TEXTIL"},{"lang":"de","value":"HOLZ/ Z.T.TEXTIL"}],"type":"9","active":true}
,{"id":"128","name":[{"lang":"en","value":"HOLZBODEN"},{"lang":"de","value":"HOLZBODEN"}],"type":"9","active":true}
,{"id":"129","name":[{"lang":"en","value":"HOLZBODEN VERSIEGELT"},{"lang":"de","value":"HOLZBODEN VERSIEGELT"}],"type":"9","active":true}
,{"id":"130","name":[{"lang":"en","value":"IND-HART"},{"lang":"de","value":"IND-HART"}],"type":"9","active":true}
,{"id":"131","name":[{"lang":"en","value":"IND/HOLZ"},{"lang":"de","value":"IND/HOLZ"}],"type":"9","active":true}
,{"id":"132","name":[{"lang":"en","value":"INDUSTRIE"},{"lang":"de","value":"INDUSTRIE"}],"type":"9","active":true}
,{"id":"133","name":[{"lang":"en","value":"INDUSTRIE VERSIEGELT"},{"lang":"de","value":"INDUSTRIE VERSIEGELT"}],"type":"9","active":true}
,{"id":"134","name":[{"lang":"en","value":"INDUSTRIE VERSIEGELT"},{"lang":"de","value":"INDUSTRIE VERSIEGELT"}],"type":"10","active":true}
,{"id":"135","name":[{"lang":"en","value":"INDUSTRIE WEISS"},{"lang":"de","value":"INDUSTRIE WEISS"}],"type":"9","active":true}
,{"id":"136","name":[{"lang":"en","value":"INDUSTRIE-VERSIEGELUNG"},{"lang":"de","value":"INDUSTRIE-VERSIEGELUNG"}],"type":"9","active":true}
,{"id":"137","name":[{"lang":"en","value":"INDUSTRIE/HOLZ"},{"lang":"de","value":"INDUSTRIE/HOLZ"}],"type":"9","active":true}
,{"id":"138","name":[{"lang":"en","value":"INDUSTRIE/STAHLANKERPLATTEN"},{"lang":"de","value":"INDUSTRIE/STAHLANKERPLATTEN"}],"type":"9","active":true}
,{"id":"139","name":[{"lang":"en","value":"INDUSTRIEBELAG"},{"lang":"de","value":"INDUSTRIEBELAG"}],"type":"9","active":true}
,{"id":"140","name":[{"lang":"en","value":"INDUSTRIEBODEN"},{"lang":"de","value":"INDUSTRIEBODEN"}],"type":"9","active":true}
,{"id":"141","name":[{"lang":"en","value":"INDUSTRIEBODEN\r\nINDUSTRIEBODEN"},{"lang":"de","value":"INDUSTRIEBODEN\r\nINDUSTRIEBODEN"}],"type":"9","active":true}
,{"id":"142","name":[{"lang":"en","value":"INDUSTRIEVERS STRUKTUR"},{"lang":"de","value":"INDUSTRIEVERS STRUKTUR"}],"type":"9","active":true}
,{"id":"143","name":[{"lang":"en","value":"INDUSTRIEVERSIEGELUNG"},{"lang":"de","value":"INDUSTRIEVERSIEGELUNG"}],"type":"9","active":true}
,{"id":"144","name":[{"lang":"en","value":"INDUSTRIEVERSIEGELUNG"},{"lang":"de","value":"INDUSTRIEVERSIEGELUNG"}],"type":"10","active":true}
,{"id":"145","name":[{"lang":"en","value":"INDUSTRIEVERSIEGELUNG (METALL)"},{"lang":"de","value":"INDUSTRIEVERSIEGELUNG (METALL)"}],"type":"9","active":true}
,{"id":"146","name":[{"lang":"en","value":"INDUSTRIEVERSIEGELUNG / ASPHAL"},{"lang":"de","value":"INDUSTRIEVERSIEGELUNG / ASPHAL"}],"type":"9","active":true}
,{"id":"147","name":[{"lang":"en","value":"INDUSTRIEVERSIEGELUNG STRUKTUR"},{"lang":"de","value":"INDUSTRIEVERSIEGELUNG STRUKTUR"}],"type":"9","active":true}
,{"id":"148","name":[{"lang":"en","value":"INDUSTRIEVERSIEGELUNG/ASPHAL"},{"lang":"de","value":"INDUSTRIEVERSIEGELUNG/ASPHAL"}],"type":"9","active":true}
,{"id":"149","name":[{"lang":"en","value":"INDUSTRIEVERSIEGLEUNG"},{"lang":"de","value":"INDUSTRIEVERSIEGLEUNG"}],"type":"9","active":true}
,{"id":"150","name":[{"lang":"en","value":"KAUTSCHUK"},{"lang":"de","value":"KAUTSCHUK"}],"type":"9","active":true}
,{"id":"151","name":[{"lang":"en","value":"KAUTSCHUK (GUMMINOPPEN)"},{"lang":"de","value":"KAUTSCHUK (GUMMINOPPEN)"}],"type":"9","active":true}
,{"id":"152","name":[{"lang":"en","value":"KAUTSCHUK DOPPELBODEN"},{"lang":"de","value":"KAUTSCHUK DOPPELBODEN"}],"type":"9","active":true}
,{"id":"153","name":[{"lang":"en","value":"KAUTSCHUKBELAG"},{"lang":"de","value":"KAUTSCHUKBELAG"}],"type":"9","active":true}
,{"id":"154","name":[{"lang":"en","value":"KAUTSCHUKBELAG"},{"lang":"de","value":"KAUTSCHUKBELAG"}],"type":"10","active":true}
,{"id":"155","name":[{"lang":"en","value":"KIES"},{"lang":"de","value":"KIES"}],"type":"10","active":true}
,{"id":"156","name":[{"lang":"en","value":"KNOCHENSTEINE"},{"lang":"de","value":"KNOCHENSTEINE"}],"type":"9","active":true}
,{"id":"157","name":[{"lang":"en","value":"KNOCHENSTEINE"},{"lang":"de","value":"KNOCHENSTEINE"}],"type":"10","active":true}
,{"id":"158","name":[{"lang":"en","value":"KUNST"},{"lang":"de","value":"KUNST"}],"type":"9","active":true}
,{"id":"159","name":[{"lang":"en","value":"KUNSTBODEN"},{"lang":"de","value":"KUNSTBODEN"}],"type":"9","active":true}
,{"id":"160","name":[{"lang":"en","value":"KUNSTBODEN + PODEST"},{"lang":"de","value":"KUNSTBODEN + PODEST"}],"type":"9","active":true}
,{"id":"161","name":[{"lang":"en","value":"KUNSTSTEIN"},{"lang":"de","value":"KUNSTSTEIN"}],"type":"9","active":true}
,{"id":"162","name":[{"lang":"en","value":"KUNSTSTEIN (TERAZZO)"},{"lang":"de","value":"KUNSTSTEIN (TERAZZO)"}],"type":"9","active":true}
,{"id":"163","name":[{"lang":"en","value":"KUNSTSTEIN (TRAZZO)"},{"lang":"de","value":"KUNSTSTEIN (TRAZZO)"}],"type":"9","active":true}
,{"id":"164","name":[{"lang":"en","value":"KUNSTSTOFF"},{"lang":"de","value":"KUNSTSTOFF"}],"type":"9","active":true}
,{"id":"165","name":[{"lang":"en","value":"LACKIERTER BETON"},{"lang":"de","value":"LACKIERTER BETON"}],"type":"9","active":true}
,{"id":"166","name":[{"lang":"en","value":"LACKIERTES BETON"},{"lang":"de","value":"LACKIERTES BETON"}],"type":"9","active":true}
,{"id":"167","name":[{"lang":"en","value":"LACKIERTES RIFFELBLECH"},{"lang":"de","value":"LACKIERTES RIFFELBLECH"}],"type":"9","active":true}
,{"id":"168","name":[{"lang":"en","value":"LENOLIUM"},{"lang":"de","value":"LENOLIUM"}],"type":"9","active":true}
,{"id":"169","name":[{"lang":"en","value":"LINO"},{"lang":"de","value":"LINO"}],"type":"9","active":true}
,{"id":"170","name":[{"lang":"en","value":"LINOLEUM"},{"lang":"de","value":"LINOLEUM"}],"type":"9","active":true}
,{"id":"171","name":[{"lang":"en","value":"LINOLIUM"},{"lang":"de","value":"LINOLIUM"}],"type":"9","active":true}
,{"id":"172","name":[{"lang":"en","value":"LöCHERHOLZ UND TEPPICH"},{"lang":"de","value":"LöCHERHOLZ UND TEPPICH"}],"type":"9","active":true}
,{"id":"173","name":[{"lang":"en","value":"MAGNERSITESTRICH"},{"lang":"de","value":"MAGNERSITESTRICH"}],"type":"9","active":true}
,{"id":"174","name":[{"lang":"en","value":"MARMOR ?"},{"lang":"de","value":"MARMOR ?"}],"type":"9","active":true}
,{"id":"175","name":[{"lang":"en","value":"MEISTERBüRO"},{"lang":"de","value":"MEISTERBüRO"}],"type":"9","active":true}
,{"id":"176","name":[{"lang":"en","value":"METALL"},{"lang":"de","value":"METALL"}],"type":"9","active":true}
,{"id":"177","name":[{"lang":"en","value":"METALL"},{"lang":"de","value":"METALL"}],"type":"10","active":true}
,{"id":"178","name":[{"lang":"en","value":"METALL / PVC"},{"lang":"de","value":"METALL / PVC"}],"type":"9","active":true}
,{"id":"179","name":[{"lang":"en","value":"METALLBODEN"},{"lang":"de","value":"METALLBODEN"}],"type":"9","active":true}
,{"id":"180","name":[{"lang":"en","value":"METALLRIFFELBLECHBODEN"},{"lang":"de","value":"METALLRIFFELBLECHBODEN"}],"type":"9","active":true}
,{"id":"181","name":[{"lang":"en","value":"METALLTR INDUSTRIEVERSIEGELUNG"},{"lang":"de","value":"METALLTR INDUSTRIEVERSIEGELUNG"}],"type":"9","active":true}
,{"id":"182","name":[{"lang":"en","value":"METALLTREPPE"},{"lang":"de","value":"METALLTREPPE"}],"type":"9","active":true}
,{"id":"183","name":[{"lang":"en","value":"NADEL"},{"lang":"de","value":"NADEL"}],"type":"9","active":true}
,{"id":"184","name":[{"lang":"en","value":"NADELFILZ"},{"lang":"de","value":"NADELFILZ"}],"type":"9","active":true}
,{"id":"185","name":[{"lang":"en","value":"NADELVLIES"},{"lang":"de","value":"NADELVLIES"}],"type":"9","active":true}
,{"id":"186","name":[{"lang":"en","value":"NATURSTEIN"},{"lang":"de","value":"NATURSTEIN"}],"type":"9","active":true}
,{"id":"187","name":[{"lang":"en","value":"NATURSTEIN"},{"lang":"de","value":"NATURSTEIN"}],"type":"10","active":true}
,{"id":"188","name":[{"lang":"en","value":"NATURSTEIN (GRANIT)"},{"lang":"de","value":"NATURSTEIN (GRANIT)"}],"type":"9","active":true}
,{"id":"189","name":[{"lang":"en","value":"NATURSTEIN / ABSTREIFER"},{"lang":"de","value":"NATURSTEIN / ABSTREIFER"}],"type":"9","active":true}
,{"id":"190","name":[{"lang":"en","value":"NATURSTEIN/PARKETT"},{"lang":"de","value":"NATURSTEIN/PARKETT"}],"type":"9","active":true}
,{"id":"191","name":[{"lang":"en","value":"NATURSTEIN/PARKETT"},{"lang":"de","value":"NATURSTEIN/PARKETT"}],"type":"10","active":true}
,{"id":"192","name":[{"lang":"en","value":"NATURSTEIN/TARTAN"},{"lang":"de","value":"NATURSTEIN/TARTAN"}],"type":"9","active":true}
,{"id":"193","name":[{"lang":"en","value":"NATURSTEIN/TARTAN"},{"lang":"de","value":"NATURSTEIN/TARTAN"}],"type":"10","active":true}
,{"id":"194","name":[{"lang":"en","value":"NATURSTEINFLIESEN"},{"lang":"de","value":"NATURSTEINFLIESEN"}],"type":"9","active":true}
,{"id":"195","name":[{"lang":"en","value":"NATURSTEINFLIESEN"},{"lang":"de","value":"NATURSTEINFLIESEN"}],"type":"10","active":true}
,{"id":"196","name":[{"lang":"en","value":"NATURWERKSTEIN"},{"lang":"de","value":"NATURWERKSTEIN"}],"type":"9","active":true}
,{"id":"197","name":[{"lang":"en","value":"NICHTBELEGUNG"},{"lang":"de","value":"NICHTBELEGUNG"}],"type":"9","active":true}
,{"id":"198","name":[{"lang":"en","value":"NICHTRAUCHER"},{"lang":"de","value":"NICHTRAUCHER"}],"type":"9","active":true}
,{"id":"199","name":[{"lang":"en","value":"NOPPEN"},{"lang":"de","value":"NOPPEN"}],"type":"9","active":true}
,{"id":"200","name":[{"lang":"en","value":"NOPPENBODEN"},{"lang":"de","value":"NOPPENBODEN"}],"type":"9","active":true}
,{"id":"201","name":[{"lang":"en","value":"NORAMENT GRANO"},{"lang":"de","value":"NORAMENT GRANO"}],"type":"9","active":true}
,{"id":"202","name":[{"lang":"en","value":"NORD"},{"lang":"de","value":"NORD"}],"type":"10","active":true}
,{"id":"203","name":[{"lang":"en","value":"O/0"},{"lang":"de","value":"O/0"}],"type":"9","active":true}
,{"id":"204","name":[{"lang":"en","value":"P/1"},{"lang":"de","value":"P/1"}],"type":"9","active":true}
,{"id":"205","name":[{"lang":"en","value":"PARKETT"},{"lang":"de","value":"PARKETT"}],"type":"9","active":true}
,{"id":"206","name":[{"lang":"en","value":"PARKETT"},{"lang":"de","value":"PARKETT"}],"type":"10","active":true}
,{"id":"207","name":[{"lang":"en","value":"PAUSENRAUM"},{"lang":"de","value":"PAUSENRAUM"}],"type":"9","active":true}
,{"id":"208","name":[{"lang":"en","value":"PERLON RIPS"},{"lang":"de","value":"PERLON RIPS"}],"type":"9","active":true}
,{"id":"209","name":[{"lang":"en","value":"PERSONENAUFZUG"},{"lang":"de","value":"PERSONENAUFZUG"}],"type":"9","active":true}
,{"id":"210","name":[{"lang":"en","value":"PFLASTER"},{"lang":"de","value":"PFLASTER"}],"type":"10","active":true}
,{"id":"211","name":[{"lang":"en","value":"PFLASTERSTEIN"},{"lang":"de","value":"PFLASTERSTEIN"}],"type":"9","active":true}
,{"id":"212","name":[{"lang":"en","value":"PFLASTERSTEINE"},{"lang":"de","value":"PFLASTERSTEINE"}],"type":"9","active":true}
,{"id":"213","name":[{"lang":"en","value":"PFLASTERSTEINE"},{"lang":"de","value":"PFLASTERSTEINE"}],"type":"10","active":true}
,{"id":"214","name":[{"lang":"en","value":"PLATTEN"},{"lang":"de","value":"PLATTEN"}],"type":"9","active":true}
,{"id":"215","name":[{"lang":"en","value":"PVC"},{"lang":"de","value":"PVC"}],"type":"9","active":true}
,{"id":"216","name":[{"lang":"en","value":"PVC + TEXTIL"},{"lang":"de","value":"PVC + TEXTIL"}],"type":"9","active":true}
,{"id":"217","name":[{"lang":"en","value":"PVC / TEPPICH"},{"lang":"de","value":"PVC / TEPPICH"}],"type":"9","active":true}
,{"id":"218","name":[{"lang":"en","value":"PVC /LINOLEUM"},{"lang":"de","value":"PVC /LINOLEUM"}],"type":"9","active":true}
,{"id":"219","name":[{"lang":"en","value":"PVC BODEN"},{"lang":"de","value":"PVC BODEN"}],"type":"9","active":true}
,{"id":"220","name":[{"lang":"en","value":"PVC PLATTEN"},{"lang":"de","value":"PVC PLATTEN"}],"type":"9","active":true}
,{"id":"221","name":[{"lang":"en","value":"PVC U. LÄUFER"},{"lang":"de","value":"PVC U. LÄUFER"}],"type":"9","active":true}
,{"id":"222","name":[{"lang":"en","value":"PVC-BODEN"},{"lang":"de","value":"PVC-BODEN"}],"type":"9","active":true}
,{"id":"223","name":[{"lang":"en","value":"PVC/FLIESEN"},{"lang":"de","value":"PVC/FLIESEN"}],"type":"9","active":true}
,{"id":"224","name":[{"lang":"en","value":"PVC/GUMMI"},{"lang":"de","value":"PVC/GUMMI"}],"type":"9","active":true}
,{"id":"225","name":[{"lang":"en","value":"PVC/LINOLEUM"},{"lang":"de","value":"PVC/LINOLEUM"}],"type":"9","active":true}
,{"id":"226","name":[{"lang":"en","value":"PVC/TEPPICH"},{"lang":"de","value":"PVC/TEPPICH"}],"type":"9","active":true}
,{"id":"227","name":[{"lang":"en","value":"PVC/TEXTIL"},{"lang":"de","value":"PVC/TEXTIL"}],"type":"9","active":true}
,{"id":"228","name":[{"lang":"en","value":"RASENGITTER"},{"lang":"de","value":"RASENGITTER"}],"type":"10","active":true}
,{"id":"229","name":[{"lang":"en","value":"RASENGITTER BETONIERT"},{"lang":"de","value":"RASENGITTER BETONIERT"}],"type":"10","active":true}
,{"id":"230","name":[{"lang":"en","value":"RASENGITTERSTEINE"},{"lang":"de","value":"RASENGITTERSTEINE"}],"type":"10","active":true}
,{"id":"231","name":[{"lang":"en","value":"RIFFELBLECH"},{"lang":"de","value":"RIFFELBLECH"}],"type":"9","active":true}
,{"id":"232","name":[{"lang":"en","value":"RIFFELBLECH LACKIERT"},{"lang":"de","value":"RIFFELBLECH LACKIERT"}],"type":"9","active":true}
,{"id":"233","name":[{"lang":"en","value":"RIFFELSTAHL"},{"lang":"de","value":"RIFFELSTAHL"}],"type":"9","active":true}
,{"id":"234","name":[{"lang":"en","value":"ROHBETON"},{"lang":"de","value":"ROHBETON"}],"type":"9","active":true}
,{"id":"235","name":[{"lang":"en","value":"RWA"},{"lang":"de","value":"RWA"}],"type":"9","active":true}
,{"id":"236","name":[{"lang":"en","value":"SAUBERLAUFZONE FUTURA"},{"lang":"de","value":"SAUBERLAUFZONE FUTURA"}],"type":"9","active":true}
,{"id":"237","name":[{"lang":"en","value":"SCHIEFER"},{"lang":"de","value":"SCHIEFER"}],"type":"9","active":true}
,{"id":"238","name":[{"lang":"en","value":"SCHMUTZFANGL."},{"lang":"de","value":"SCHMUTZFANGL."}],"type":"9","active":true}
,{"id":"239","name":[{"lang":"en","value":"SCHMUTZFANGLÄUFER"},{"lang":"de","value":"SCHMUTZFANGLÄUFER"}],"type":"9","active":true}
,{"id":"240","name":[{"lang":"en","value":"SCHMUTZFANGLÄUFER"},{"lang":"de","value":"SCHMUTZFANGLÄUFER"}],"type":"10","active":true}
,{"id":"241","name":[{"lang":"en","value":"SCHMUTZFANGLäUFER"},{"lang":"de","value":"SCHMUTZFANGLäUFER"}],"type":"9","active":true}
,{"id":"242","name":[{"lang":"en","value":"SCHMUTZFÄNGER"},{"lang":"de","value":"SCHMUTZFÄNGER"}],"type":"9","active":true}
,{"id":"243","name":[{"lang":"en","value":"SCHMUTZFÄNGER"},{"lang":"de","value":"SCHMUTZFÄNGER"}],"type":"10","active":true}
,{"id":"244","name":[{"lang":"en","value":"SCHMUTZFäNGER"},{"lang":"de","value":"SCHMUTZFäNGER"}],"type":"9","active":true}
,{"id":"245","name":[{"lang":"en","value":"SCHMUTZFäNGER/GUMMI"},{"lang":"de","value":"SCHMUTZFäNGER/GUMMI"}],"type":"9","active":true}
,{"id":"246","name":[{"lang":"en","value":"SHED-GLAS"},{"lang":"de","value":"SHED-GLAS"}],"type":"9","active":true}
,{"id":"247","name":[{"lang":"en","value":"SHED-GLAS"},{"lang":"de","value":"SHED-GLAS"}],"type":"10","active":true}
,{"id":"248","name":[{"lang":"en","value":"STAHL"},{"lang":"de","value":"STAHL"}],"type":"9","active":true}
,{"id":"249","name":[{"lang":"en","value":"STAHL - ABSATZ OBEN KAUTSCHUK"},{"lang":"de","value":"STAHL - ABSATZ OBEN KAUTSCHUK"}],"type":"9","active":true}
,{"id":"250","name":[{"lang":"en","value":"STAHLANKERPLATTEN"},{"lang":"de","value":"STAHLANKERPLATTEN"}],"type":"9","active":true}
,{"id":"251","name":[{"lang":"en","value":"STAHLBLECH"},{"lang":"de","value":"STAHLBLECH"}],"type":"9","active":true}
,{"id":"252","name":[{"lang":"en","value":"STAHLBODEN"},{"lang":"de","value":"STAHLBODEN"}],"type":"9","active":true}
,{"id":"253","name":[{"lang":"en","value":"STAHLPODEST"},{"lang":"de","value":"STAHLPODEST"}],"type":"9","active":true}
,{"id":"254","name":[{"lang":"en","value":"STAHLRIFFELBLECH"},{"lang":"de","value":"STAHLRIFFELBLECH"}],"type":"9","active":true}
,{"id":"255","name":[{"lang":"en","value":"STAHLTREPPE"},{"lang":"de","value":"STAHLTREPPE"}],"type":"9","active":true}
,{"id":"256","name":[{"lang":"en","value":"STAHLTREPPE"},{"lang":"de","value":"STAHLTREPPE"}],"type":"10","active":true}
,{"id":"257","name":[{"lang":"en","value":"STEIN"},{"lang":"de","value":"STEIN"}],"type":"9","active":true}
,{"id":"258","name":[{"lang":"en","value":"STEIN"},{"lang":"de","value":"STEIN"}],"type":"10","active":true}
,{"id":"259","name":[{"lang":"en","value":"STEIN- KLEINE TEILFLäCHE PVC"},{"lang":"de","value":"STEIN- KLEINE TEILFLäCHE PVC"}],"type":"9","active":true}
,{"id":"260","name":[{"lang":"en","value":"STEINBODEN"},{"lang":"de","value":"STEINBODEN"}],"type":"9","active":true}
,{"id":"261","name":[{"lang":"en","value":"STEINE"},{"lang":"de","value":"STEINE"}],"type":"10","active":true}
,{"id":"262","name":[{"lang":"en","value":"STEINFLIESEN"},{"lang":"de","value":"STEINFLIESEN"}],"type":"9","active":true}
,{"id":"263","name":[{"lang":"en","value":"STEINPLATTEN"},{"lang":"de","value":"STEINPLATTEN"}],"type":"9","active":true}
,{"id":"264","name":[{"lang":"en","value":"STEINPLATTEN"},{"lang":"de","value":"STEINPLATTEN"}],"type":"10","active":true}
,{"id":"265","name":[{"lang":"en","value":"STEINTEPPICH"},{"lang":"de","value":"STEINTEPPICH"}],"type":"9","active":true}
,{"id":"266","name":[{"lang":"en","value":"STEINTEPPICH"},{"lang":"de","value":"STEINTEPPICH"}],"type":"10","active":true}
,{"id":"267","name":[{"lang":"en","value":"STEINZEUG"},{"lang":"de","value":"STEINZEUG"}],"type":"9","active":true}
,{"id":"268","name":[{"lang":"en","value":"STEINZEUGFLIESEN 15/15"},{"lang":"de","value":"STEINZEUGFLIESEN 15/15"}],"type":"9","active":true}
,{"id":"269","name":[{"lang":"en","value":"STRASSENBELAG STRUKTURIERT"},{"lang":"de","value":"STRASSENBELAG STRUKTURIERT"}],"type":"9","active":true}
,{"id":"270","name":[{"lang":"en","value":"STRASSENBELAG STRUKTURIERT"},{"lang":"de","value":"STRASSENBELAG STRUKTURIERT"}],"type":"10","active":true}
,{"id":"271","name":[{"lang":"en","value":"STRHTS"},{"lang":"de","value":"STRHTS"}],"type":"9","active":true}
,{"id":"272","name":[{"lang":"en","value":"STRUKTURBELAG"},{"lang":"de","value":"STRUKTURBELAG"}],"type":"9","active":true}
,{"id":"273","name":[{"lang":"en","value":"SYNTHESEKAUTSCHUK"},{"lang":"de","value":"SYNTHESEKAUTSCHUK"}],"type":"9","active":true}
,{"id":"274","name":[{"lang":"en","value":"SYNTHETIKKAUTSCHUK"},{"lang":"de","value":"SYNTHETIKKAUTSCHUK"}],"type":"9","active":true}
,{"id":"275","name":[{"lang":"en","value":"TEAMLEITER"},{"lang":"de","value":"TEAMLEITER"}],"type":"9","active":true}
,{"id":"276","name":[{"lang":"en","value":"TEER"},{"lang":"de","value":"TEER"}],"type":"9","active":true}
,{"id":"277","name":[{"lang":"en","value":"TEER"},{"lang":"de","value":"TEER"}],"type":"10","active":true}
,{"id":"278","name":[{"lang":"en","value":"TEER / PFLASTERSTEINE"},{"lang":"de","value":"TEER / PFLASTERSTEINE"}],"type":"10","active":true}
,{"id":"279","name":[{"lang":"en","value":"TEILWEISE KUNST"},{"lang":"de","value":"TEILWEISE KUNST"}],"type":"9","active":true}
,{"id":"280","name":[{"lang":"en","value":"TEILWEISE TEXTIL"},{"lang":"de","value":"TEILWEISE TEXTIL"}],"type":"9","active":true}
,{"id":"281","name":[{"lang":"en","value":"TEIWEISE KUNST"},{"lang":"de","value":"TEIWEISE KUNST"}],"type":"9","active":true}
,{"id":"282","name":[{"lang":"en","value":"TEPICHBODEN"},{"lang":"de","value":"TEPICHBODEN"}],"type":"9","active":true}
,{"id":"283","name":[{"lang":"en","value":"TEPPICH"},{"lang":"de","value":"TEPPICH"}],"type":"9","active":true}
,{"id":"284","name":[{"lang":"en","value":"TEPPICH - NIEDERFLOR"},{"lang":"de","value":"TEPPICH - NIEDERFLOR"}],"type":"9","active":true}
,{"id":"285","name":[{"lang":"en","value":"TEPPICH / KUNSTSTOFF"},{"lang":"de","value":"TEPPICH / KUNSTSTOFF"}],"type":"9","active":true}
,{"id":"286","name":[{"lang":"en","value":"TEPPICH DOPPELBODEN"},{"lang":"de","value":"TEPPICH DOPPELBODEN"}],"type":"9","active":true}
,{"id":"287","name":[{"lang":"en","value":"TEPPICH FLUR"},{"lang":"de","value":"TEPPICH FLUR"}],"type":"9","active":true}
,{"id":"288","name":[{"lang":"en","value":"TEPPICH MB"},{"lang":"de","value":"TEPPICH MB"}],"type":"9","active":true}
,{"id":"289","name":[{"lang":"en","value":"TEPPICH NIEDERFLOR"},{"lang":"de","value":"TEPPICH NIEDERFLOR"}],"type":"9","active":true}
,{"id":"290","name":[{"lang":"en","value":"TEPPICH- DOPPELBODEN"},{"lang":"de","value":"TEPPICH- DOPPELBODEN"}],"type":"9","active":true}
,{"id":"291","name":[{"lang":"en","value":"TEPPICH/DOPPELBODEN"},{"lang":"de","value":"TEPPICH/DOPPELBODEN"}],"type":"9","active":true}
,{"id":"292","name":[{"lang":"en","value":"TEPPICH/PVC"},{"lang":"de","value":"TEPPICH/PVC"}],"type":"9","active":true}
,{"id":"293","name":[{"lang":"en","value":"TEPPICHBODEN"},{"lang":"de","value":"TEPPICHBODEN"}],"type":"9","active":true}
,{"id":"294","name":[{"lang":"en","value":"TEXTIL"},{"lang":"de","value":"TEXTIL"}],"type":"9","active":true}
,{"id":"295","name":[{"lang":"en","value":"TEXTIL"},{"lang":"de","value":"TEXTIL"}],"type":"10","active":true}
,{"id":"296","name":[{"lang":"en","value":"TEXTIL + PODEST"},{"lang":"de","value":"TEXTIL + PODEST"}],"type":"9","active":true}
,{"id":"297","name":[{"lang":"en","value":"TEXTIL UND KUNST"},{"lang":"de","value":"TEXTIL UND KUNST"}],"type":"9","active":true}
,{"id":"298","name":[{"lang":"en","value":"TEXTIL/KUNST"},{"lang":"de","value":"TEXTIL/KUNST"}],"type":"9","active":true}
,{"id":"299","name":[{"lang":"en","value":"TEXTILBODEN"},{"lang":"de","value":"TEXTILBODEN"}],"type":"9","active":true}
,{"id":"300","name":[{"lang":"en","value":"TREPPE HART-KUNST"},{"lang":"de","value":"TREPPE HART-KUNST"}],"type":"9","active":true}
,{"id":"301","name":[{"lang":"en","value":"TRÄNENBLECH"},{"lang":"de","value":"TRÄNENBLECH"}],"type":"9","active":true}
,{"id":"302","name":[{"lang":"en","value":"TRäNENBLECH"},{"lang":"de","value":"TRäNENBLECH"}],"type":"9","active":true}
,{"id":"303","name":[{"lang":"en","value":"VERSCHIEDENER BELAG"},{"lang":"de","value":"VERSCHIEDENER BELAG"}],"type":"9","active":true}
,{"id":"304","name":[{"lang":"en","value":"VERSIEGELT"},{"lang":"de","value":"VERSIEGELT"}],"type":"9","active":true}
,{"id":"305","name":[{"lang":"en","value":"VERSIEGELTER BETON"},{"lang":"de","value":"VERSIEGELTER BETON"}],"type":"9","active":true}
,{"id":"306","name":[{"lang":"en","value":"VERSIEGELTER ESTRICH"},{"lang":"de","value":"VERSIEGELTER ESTRICH"}],"type":"9","active":true}
,{"id":"307","name":[{"lang":"en","value":"VERSIEGELUNG"},{"lang":"de","value":"VERSIEGELUNG"}],"type":"9","active":true}
,{"id":"308","name":[{"lang":"en","value":"VERSIEGELUNG OELFEST"},{"lang":"de","value":"VERSIEGELUNG OELFEST"}],"type":"9","active":true}
,{"id":"309","name":[{"lang":"en","value":"VERSIEGELUNG TEPPICH"},{"lang":"de","value":"VERSIEGELUNG TEPPICH"}],"type":"9","active":true}
,{"id":"310","name":[{"lang":"en","value":"VERSIEGETER BETON"},{"lang":"de","value":"VERSIEGETER BETON"}],"type":"9","active":true}
,{"id":"311","name":[{"lang":"en","value":"VORPLATZ-EINGANG"},{"lang":"de","value":"VORPLATZ-EINGANG"}],"type":"9","active":true}
,{"id":"312","name":[{"lang":"en","value":"WASCHBETON"},{"lang":"de","value":"WASCHBETON"}],"type":"9","active":true}
,{"id":"313","name":[{"lang":"en","value":"WC-BEHINDERTEN"},{"lang":"de","value":"WC-BEHINDERTEN"}],"type":"9","active":true}
,{"id":"314","name":[{"lang":"en","value":"WENDELTREPPE"},{"lang":"de","value":"WENDELTREPPE"}],"type":"9","active":true}
,{"id":"315","name":[{"lang":"en","value":"WINDFANG"},{"lang":"de","value":"WINDFANG"}],"type":"9","active":true}
,{"id":"316","name":[{"lang":"en","value":"WIRD ERNEUERT"},{"lang":"de","value":"WIRD ERNEUERT"}],"type":"9","active":true}
,{"id":"317","name":[{"lang":"en","value":"Y1-Z/39-43"},{"lang":"de","value":"Y1-Z/39-43"}],"type":"9","active":true}
,{"id":"318","name":[{"lang":"en","value":"Z.T. KUNSTBODEN"},{"lang":"de","value":"Z.T. KUNSTBODEN"}],"type":"9","active":true}
,{"id":"319","name":[{"lang":"en","value":"ZUM TEIL MIT KUNST"},{"lang":"de","value":"ZUM TEIL MIT KUNST"}],"type":"9","active":true}
,{"id":"320","name":[{"lang":"en","value":"ZWISCHENBODEN"},{"lang":"de","value":"ZWISCHENBODEN"}],"type":"9","active":true}
,{"id":"322","name":[{"lang":"en","value":"keine"},{"lang":"de","value":"keine"}],"type":"10","active":true}
,{"id":"321","name":[{"lang":"en","value":"keine"},{"lang":"de","value":"keine"}],"type":"9","active":true}
,{"id":"323","name":[{"lang":"en","value":"ÖLFESTE VERSIEGELUNG"},{"lang":"de","value":"ÖLFESTE VERSIEGELUNG"}],"type":"9","active":true}
,{"id":"324","name":[{"lang":"en","value":"ÖLFESTE VERSIEGELUNG"},{"lang":"de","value":"ÖLFESTE VERSIEGELUNG"}],"type":"10","active":true}
,{"id":"325","name":[{"lang":"en","value":"öLFESTE VERSIEGELUNG"},{"lang":"de","value":"öLFESTE VERSIEGELUNG"}],"type":"9","active":true}
]}
    '

    DECLARE @itemList NVARCHAR(MAX)

	DECLARE @archive TABLE
	(
	   ActionType VARCHAR(50),
	   [functionalId] NVARCHAR(25)
	);

    SELECT @itemList = [value]
	FROM OPENJSON(@json,'$')

	MERGE INTO [std].[flooring] AS t
	USING
	(
		SELECT 
			[app].[fnGetFaplisTranslationValue](name,N'de') AS [name],
			id AS [faplisId],
			active AS [isActive]
		FROM OPENJSON(@itemList)
			WITH (  name NVARCHAR(MAX) AS JSON,
                    id NVARCHAR(100),
					active BIT
			)
	) AS s
	ON s.[faplisId] = t.[faplisId]
	WHEN NOT MATCHED THEN
		INSERT ([name],[faplisId],[isActive])
		VALUES (s.[name],s.[faplisId],s.[isActive])
	WHEN MATCHED AND
	(
		t.[name] <> s.[name] OR
		t.[isActive] <> s.[isActive]
	) THEN
		UPDATE SET
			t.[name] = s.[name],
			t.[isActive] = s.[isActive]
	OUTPUT $action AS [ActionType],inserted.faplisId INTO @archive;

	--PRINT N'Records: '+ ISNULL(STRING_AGG(q.[ActionType] + ': ' + CAST(q.[anz] AS NVARCHAR),', '),'0') FROM (SELECT [ActionType],COUNT(1) AS [anz] FROM @archive GROUP BY [ActionType]) q

    MERGE INTO [std].[flooring] t
    USING
    (
        SELECT 
            f.[functionalId] COLLATE SQL_Latin1_General_CP1_CI_AS AS [faplisId]
            ,v.[Name] COLLATE SQL_Latin1_General_CP1_CI_AS AS [name] 
            ,f.[isActive] AS [isActive]
            ,f.[Created] AS [insertedAt]
            ,f.[Modified] AS [updatedAt]
        FROM [archiv].[faplis_flooring] f
        INNER JOIN [archiv].[faplis_flooring_V] v
            ON v.[id] = f.[id]
    ) s
    ON s.[faplisId] = t.[faplisId]
    WHEN NOT MATCHED THEN
        INSERT ([name],[isActive],[faplisId],[insertedAt],[insertedBy])
        VALUES (s.[name],s.[isActive],s.[faplisId],[insertedAt],1)
    WHEN MATCHED THEN
        UPDATE SET
            t.[name] = s.[name]
            ,t.[isActive] = s.[isActive]
            ,t.[updatedAt] = s.[updatedAt]
            ,t.[updatedBy] = 1
    ;

END --flooring
GO
