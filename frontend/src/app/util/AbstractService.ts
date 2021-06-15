import { HttpClient, HttpHeaders } from "@angular/common/http";

export class AbstractService {
    protected headers: HttpHeaders;
    protected authHeaders: HttpHeaders;

    constructor(
        protected http: HttpClient
    ) {
        this.headers = new HttpHeaders({
            "Content-Type": "application/json"
        });

        
        this.authHeaders = new HttpHeaders({
            "Content-Type": "application/json"
        });
    }

    protected includeAccessTokenToHeaders(): void {
        if (localStorage.getItem("accessToken") != null && !this.authHeaders.has("Authorization"))
            this.authHeaders = this.authHeaders.append("Authorization", localStorage.getItem("accessToken"));
    }
}