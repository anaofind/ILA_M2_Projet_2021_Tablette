package fr.istic.projet.servicefirebaseapp.model;


public class FileDTO {
    private String fileName;
    private String contentType;
    private String fileDownloadUri;

    public FileDTO() {
    }

    public FileDTO(String fileName, String contentType, String fileDownloadUri) {
        this.fileName = fileName;
        this.contentType = contentType;
        this.fileDownloadUri = fileDownloadUri;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getContentType() {
        return contentType;
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    public String getFileDownloadUri() {
        return fileDownloadUri;
    }

    public void setFileDownloadUri(String fileDownloadUri) {
        this.fileDownloadUri = fileDownloadUri;
    }


    @Override
    public String toString() {
        return "FileDTO{" +
                "fileName='" + fileName + '\'' +
                ", contentType='" + contentType + '\'' +
                ", fileDownloadUri='" + fileDownloadUri+
                '}';
    }
}
