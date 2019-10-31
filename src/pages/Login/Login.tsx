import { IonContent, IonPage } from '@ionic/react';
import React from 'react';
import './Login.css';

const Login: React.FC = () => {
    return (
        <IonPage>
            <IonContent className="ion-padding"> 
                <div className="limiter">
                    <div className="container-login100">
                        <div className="wrap-login100">
                            <form className="login100-form validate-form">
                                <span className="login100-form-title p-b-48">
                                    <img src="assets/images/logo-del100.png"></img>
                                </span>

                                <div className="wrap-input100 validate-input" data-validate = "Valid email is: a@b.c">
                                    <input className="input100" type="text" name="email"/>
                                    <span className="focus-input100" data-placeholder="Identifiant"></span>
                                </div>

                                <div className="wrap-input100 validate-input" data-validate="Enter password">
                                    <span className="btn-show-pass">
                                        <i className="zmdi zmdi-eye"></i>
                                    </span>
                                    <input className="input100" type="password" name="pass"/>
                                    <span className="focus-input100" data-placeholder="Mot de passe"></span>
                                </div>

                                <div className="container-login100-form-btn">
                                    <div className="wrap-login100-form-btn">
                                        <div className="login100-form-bgbtn"></div>
                                        <button className="login100-form-btn">
                                            Login
                                        </button>
                                    </div>
                                </div>

                                <div className="text-center p-t-115">
                                    <span className="txt1">
                                        Vous n'avez pas de compte ?
                                    </span>
                                    <a className="txt2" href="/home">
                                        Demander un compte
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </IonContent>
        </IonPage>
    );
};

export default Login;
