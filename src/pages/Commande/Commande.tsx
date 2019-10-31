import { IonContent, IonPage, IonHeader, IonToolbar, IonButtons, IonButton, IonTitle, IonSegment, IonSegmentButton, IonLabel, IonList, IonItem, IonAvatar, IonBadge } from '@ionic/react';
import React, { useState } from 'react';

export const DateAuj = ({ dateauj }: { dateauj: string }) => <IonTitle>{dateauj}</IonTitle>;

interface Repas {
    id: number,
    titre: string,
    img: string,
    description: string,
    qte: number,
    categorie: string,
    type: string,
}

const Commande: React.FC = (props) => {
    const [currentList, setCurrentList] = useState('entree');

    function formatDate(date: Date) {
        var monthNames = [
            "Janvier", "Fevrier", "Mars",
            "Avril", "Mai", "Juin", "Juillet",
            "Aout", "Septembre", "Octobre",
            "Novembre", "Decembre"
        ];

        var day = date.getDate();
        var monthIndex = date.getMonth();
        var year = date.getFullYear();

        return day + ' ' + monthNames[monthIndex] + ' ' + year;
    }

    const setList = (event:any) => {
        if(String(event.detail.value) != currentList){
            setCurrentList(String(event.detail.value));
        }
        
    }

    let repas: Repas[] = [
        { id: 1, titre: 'Americain poulet', img: './sandwish', description: 'Sandwish au poulet', qte: 20, categorie: 'vegetarien', type: 'entree' },
        { id: 2, titre: 'Americain poulet', img: './sandwish', description: 'Sandwish au poulet', qte: 20, categorie: 'sans porc', type: 'plat' },
        { id: 3, titre: 'Americain poulet', img: './sandwish', description: 'Sandwish au poulet', qte: 20, categorie: 'poisson', type: 'dessert' },
    ];

    function AfficheRepas(props: any) {
        const listItems = repas.filter(rep => rep.type == props.type).map((rep) =>
            <IonItem>
                <IonAvatar slot="start">
                    <img src={rep.img} />
                </IonAvatar>
                <IonLabel>
                    <h2>{rep.titre}</h2>
                    <h3>{rep.categorie}</h3>
                    <p>{rep.description}</p>
                </IonLabel>
                <IonBadge color="secondary" slot="end">
                    {rep.qte}
                </IonBadge>
            </IonItem>
        );
        return (
            <IonList>{listItems}</IonList>
        );
    }

    return (
        <IonPage>
            <IonHeader>
                <IonToolbar>
                    <DateAuj dateauj={formatDate(new Date(Date.now()))} />
                    <IonButtons slot="primary">
                        <IonButton>Log Out</IonButton>
                    </IonButtons>
                </IonToolbar>
            </IonHeader>
            <IonContent className="ion-padding">
                <IonSegment onIonChange={e => setCurrentList(String(e.detail.value))} value={currentList}>
                    <IonSegmentButton value="entree" checked>
                        <IonLabel>Entrée</IonLabel>
                    </IonSegmentButton>
                    <IonSegmentButton value="plat">
                        <IonLabel>Plat</IonLabel>
                    </IonSegmentButton>
                    <IonSegmentButton value="dessert">
                        <IonLabel>Dessert</IonLabel>
                    </IonSegmentButton>
                </IonSegment>
                <AfficheRepas type={currentList}/>

            </IonContent>
        </IonPage>
    );
};

export default Commande;
